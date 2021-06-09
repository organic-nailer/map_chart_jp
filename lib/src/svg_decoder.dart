import 'dart:convert';
import 'dart:io';

import 'pref_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class SvgDecoder {
	static Future<List<PrefMapData>> getJpMap() async {
		//var file = File("packages/map_chart_jp/assets/pref-paths.json");
		//var str = await file.readAsString();
		var str = await rootBundle.loadString("packages/map_chart_jp/assets/pref-paths.json");
		List<dynamic> decoded = json.decode(str);
		List<PrefMapData> result = [];
		for(var raw in decoded) {
			if(raw["id"] == null || raw["d"] == null) continue;
			result.add(PrefMapData(
				PrefExt.fromPrefCode(raw["id"]),
				parseSvgPath(raw["d"] as String)
			));
		}
		return result;
	}
}

class PrefMapData {
	final Prefecture pref;
	final Path path;
	PrefMapData(this.pref, this.path);
}
