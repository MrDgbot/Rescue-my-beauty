import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

enum Fun {
  release,
}

Future<void> main(List<String> arguments) async {
  var parser = ArgParser()
    ..addOption('fun', abbr: 'f', allowed: Fun.values.map((e) => e.name))
    ..addOption('token', abbr: 't')
    ..addOption('artifacts', abbr: 'a');
  print(arguments);

  var parse = parser.parse(arguments);
  var token = parse['token'];
  var artifacts = parse['artifacts'];
  var shell = Shell();
  var result = await shell.run("git remote -v");
  var urlParts =
      result.first.stdout.toString().trim().split("\n").last.split("/");
  var repo = [
    urlParts[urlParts.length - 2],
    urlParts[urlParts.length - 1].split(" ").first.replaceAll(".git", '')
  ].join("/");
  switch (Fun.values.firstWhere((e) => e.name == parse['fun'])) {
    case Fun.release:
      await _release(
        shell: shell,
        repo: repo,
        token: token,
        artifacts: artifacts,
      );
      break;
  }
}

Future<void> _release({
  required Shell shell,
  required String token,
  required String repo,
  required String artifacts,
}) async {
  await shell.run("git remote set-url origin https://$token@github.com/$repo");
  var result = await shell.run("git show -s");
  var commitId =
      RegExp(r"\s([a-z\d]{40})\s").firstMatch(result.first.stdout)?.group(1);
  if (commitId == null) {
    throw StateError("Can't get ref.");
  }
  result = await shell.run('git log --pretty=format:"%an;%ae" $commitId -1');
  var pair = result.first.stdout.toString().split(";");
  var ref = commitId.substring(0, 7);
  var root = Directory.current;
  var pubspec = File(join(root.path, 'pubspec.yaml'));
  var yaml = loadYaml(pubspec.readAsStringSync());
  var version = yaml['version'] as String;
  var verArr = version.split('+');
  var tag = "v${verArr.first}_$ref";
  // result = await shell.run("git branch");
  // var branch = result.first.stdout
  //     .toString()
  //     .split("\n")
  //     .firstWhere((e) => e.startsWith("*"))
  //     .split(" ")
  //     .last;
  result = await shell.run("git ls-remote --tags");
  var tags = result.first.stdout.toString();
  var has =
      tags.split("\n").any((s) => s.split("refs/tags/").last.startsWith(tag));
  if (!has) {
    try {
      await shell.run("git"
          " -c user.name=${pair[0]}"
          " -c user.email=${pair[1]}"
          " tag $tag");
      await shell.run("git push origin $tag");
    } catch (e) {
      print(e);
    }
  }
  dynamic id;

  /// 检查tag是否发布
  try {
    var response = await shell.run(
        'gh api -H "Accept: application/vnd.github+json" /repos/$repo/releases/tags/$tag');
    id = jsonDecode(response.first.stdout.toString())?['id'];
  } catch (e) {
    print(e);
  }
  print('tag id: $id');

  /// tag未发布则创建release
  if (id == null) {
    try {
      var response = await shell
          .run('gh api --method POST -H "Accept: application/vnd.github+json" '
              '/repos/$repo/releases '
              '-f tag_name=$tag '
              '-f target_commitish=master '
              '-f name=$tag '
              '-f body="" '
              '-F draft=false '
              '-F prerelease=false '
              '-F generate_release_notes=false');
      id = jsonDecode(response.first.stdout.toString())?['id'];
    } catch (e) {
      print(e);
    }
    if (id == null) {
      throw StateError(result.first.stdout);
    }
  }
  print('release id: $id');


  /// 获取所有文件
  var files = Glob(artifacts, recursive: true).listSync(root: root.path);
  print("filesLength ${files.length}");

  /// 获取当前release的所有文件
  var assetsResult = await shell.run(
      'gh api -H "Accept: application/vnd.github+json" /repos/$repo/releases/$id/assets');

  var assets = jsonDecode(assetsResult.first.stdout.toString()) as List?;
  print('assets: ${assets?.map((e) => e['name'])}');

  for (var file in files) {
    if (file is File) {
      var filePath = file.absolute.path;
      var fileName = basename(filePath);
      print('prepare upload: $filePath');
      var exist = assets?.firstWhereOrNull((e) {
        return e['name'] == fileName;
      });
      if (exist != null) {
        print('exist asset: ${exist?['name']}');
        // delete exist assert
        var deleteResponse = await shell.run(
            'gh api -H "Accept: application/vnd.github+json" --method DELETE /repos/$repo/releases/assets/${exist?['id']}');

        print('delete end: ${deleteResponse.first.stdout}');
      }
      // upload asset.
      var uploadResponse = await shell.run('gh release upload $tag $filePath');

      print('upload end: ${uploadResponse.first.stdout}, $filePath');
    }
  }
  print('task end');
  exit(0);
}
