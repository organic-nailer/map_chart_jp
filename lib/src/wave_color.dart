import 'dart:math' as Math;

import 'package:flutter/material.dart';

class Wave2ColorMaterial {
	static Color nFromWave(double nanoMeter) {
		var c = fromWave(nanoMeter);
		var y = 0.299 * c.red + 0.587 * c.green + 0.114 * c.blue;
		if(y < 3) return c;
		var f = 100 / y;
		return Color.fromARGB(255,
			Math.max(0, Math.min(255, (c.red * f).floor())),
			Math.max(0, Math.min(255, (c.green * f).floor())),
			Math.max(0, Math.min(255, (c.blue * f).floor()))
		);
	}

	static Color fromWave(double nanoMeter) {
		if(nanoMeter < 380 || nanoMeter > 700) {
			return Colors.black;
		}
		return Color.fromARGB(255,
			Math.max(0, Math.min(255, _rFromWave(nanoMeter).floor())),
			Math.max(0, Math.min(255, _gFromWave(nanoMeter).floor())),
			Math.max(0, Math.min(255, _bFromWave(nanoMeter).floor()))
		);
	}

	static double _rFromWave(double nanoMeter) {
		if(nanoMeter < 380) return 0;
		else if(nanoMeter < 440) return -2 * nanoMeter + 880;
		else if(nanoMeter < 510) return 0;
		else if(nanoMeter < 580) return 3.64 * nanoMeter - 1857.86;
		else if(nanoMeter <= 700) return 255;
		else return 0;
	}

	static double _gFromWave(double nanoMeter) {
		if(nanoMeter < 380) return 0;
		else if(nanoMeter < 580) return 1.05 * nanoMeter - 369;
		else if(nanoMeter <= 700) return -1.42 * nanoMeter + 1061.67;
		else return 0;
	}

	static double _bFromWave(double nanoMeter) {
		if(nanoMeter < 380) return 0;
		else if(nanoMeter < 450) return 1.71 * nanoMeter - 521.43;
		else if(nanoMeter < 620) return -1.47 * nanoMeter + 911.76;
		else if(nanoMeter < 640) return 0;
		else if(nanoMeter <= 700) return nanoMeter - 640;
		else return 0;
	}
}
