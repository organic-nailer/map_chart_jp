enum Prefecture {
	Unknown,
	Hokkaido,  Aomori,    Iwate,    Miyagi,    Akita,
	Yamagata,  Fukushima, Ibaraki,  Tochigi,   Gunma,
	Saitama,   Chiba,     Tokyo,    Kanagawa,  Niigata,
	Toyama,    Ishikawa,  Fukui,    Yamanashi, Nagano,
	Gifu,      Shizuoka,  Aichi,    Mie,       Shiga,
	Kyoto,     Osaka,     Hyogo,    Nara,      Wakayama,
	Tottori,   Shimane,   Okayama,  Hiroshima, Yamaguchi,
	Tokushima, Kagawa,    Ehime,    Kochi,     Fukuoka,
	Saga,      Nagasaki,  Kumamoto, Oita,      Miyazaki,
	Kagoshima, Okinawa
}

Map<Prefecture,String> _jpName = {
	Prefecture.Hokkaido: "北海道",
	Prefecture.Aomori: "青森",
	Prefecture.Iwate: "岩手",
	Prefecture.Miyagi: "宮城",
	Prefecture.Akita: "秋田",
	Prefecture.Yamagata: "山形",
	Prefecture.Fukushima: "福島",
	Prefecture.Ibaraki: "茨城",
	Prefecture.Tochigi: "栃木",
	Prefecture.Gunma: "群馬",
	Prefecture.Saitama: "埼玉",
	Prefecture.Chiba: "千葉",
	Prefecture.Tokyo: "東京",
	Prefecture.Kanagawa: "神奈川",
	Prefecture.Niigata: "新潟",
	Prefecture.Toyama: "富山",
	Prefecture.Ishikawa: "石川",
	Prefecture.Fukui: "福井",
	Prefecture.Yamanashi: "山梨",
	Prefecture.Nagano: "長野",
	Prefecture.Gifu: "岐阜",
	Prefecture.Shizuoka: "静岡",
	Prefecture.Aichi: "愛知"
};

extension PrefExt on Prefecture {
	static Prefecture fromPrefCode(int code) {
		if(code <= 0 || code >= Prefecture.values.length) return Prefecture.Unknown;
		return Prefecture.values[code];
	}

	String getJpName() {
		return _jpName[this] ?? "不明";
	}
}
