extends Node

const INITIAL_COUNTRIES = {
	"USA": {
		"CountryNumber": 1,
		"Population": 316128839,
		"Followers": "0%",
		"BasicConversionPerDay": "Fast",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Fastest media spread but highest resistance from fact-checkers.",
		"Media": {
			"Print": {"MediaNumber": "1-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "1-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "1-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Central America": {
		"CountryNumber": 2,
		"Population": 44723159,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Social media popularity aids rapid spread in urban areas.",
		"Media": {
			"Print": {"MediaNumber": "2-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "2-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "2-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Mexico": {
		"CountryNumber": 3,
		"Population": 122332399,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "High urban acceptance, rural regions harder to convert.",
		"Media": {
			"Print": {"MediaNumber": "3-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "3-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "3-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Caribbean": {
		"CountryNumber": 4,
		"Population": 38316937,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Island isolation can accelerate adoption once introduced.",
		"Media": {
			"Print": {"MediaNumber": "4-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "4-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "4-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Canada": {
		"CountryNumber": 5,
		"Population": 35158304,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High media literacy creates strong initial resistance.",
		"Media": {
			"Print": {"MediaNumber": "5-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "5-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "5-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Greenland": {
		"CountryNumber": 6,
		"Population": 56483,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Geographic isolation limits spread but creates strong local beliefs once established.",
		"Media": {
			"Print": {"MediaNumber": "6-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "6-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "6-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Brazil": {
		"CountryNumber": 7,
		"Population": 210571282,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "High political instability aids conspiracy growth.",
		"Media": {
			"Print": {"MediaNumber": "7-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "7-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "7-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Colombia": {
		"CountryNumber": 8,
		"Population": 94464490,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Unstable regions create easy misinformation spread.",
		"Media": {
			"Print": {"MediaNumber": "8-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "8-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "8-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Argentina": {
		"CountryNumber": 9,
		"Population": 59065954,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Economic uncertainty helps misinformation spread.",
		"Media": {
			"Print": {"MediaNumber": "9-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "9-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "9-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Peru": {
		"CountryNumber": 10,
		"Population": 30375603,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Political distrust creates receptive environment.",
		"Media": {
			"Print": {"MediaNumber": "10-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "10-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "10-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Bolivia": {
		"CountryNumber": 11,
		"Population": 10671200,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Political polarization creates receptive demographics.",
		"Media": {
			"Print": {"MediaNumber": "11-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "11-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "11-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Saudi Arabia": {
		"CountryNumber": 12,
		"Population": 71752069,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Government-controlled media makes resistance high.",
		"Media": {
			"Print": {"MediaNumber": "12-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "12-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "12-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Middle east": {
		"CountryNumber": 13,
		"Population": 46000846,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Religious and political tensions make certain conspiracies spread rapidly.",
		"Media": {
			"Print": {"MediaNumber": "13-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "13-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "13-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Iraq": {
		"CountryNumber": 14,
		"Population": 33417476,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Social and political instability aids conspiracy spread.",
		"Media": {
			"Print": {"MediaNumber": "14-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "14-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "14-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"West Africa": {
		"CountryNumber": 15,
		"Population": 330752285,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Rural areas slow conversion; weak media presence.",
		"Media": {
			"Print": {"MediaNumber": "15-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "15-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "15-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"East Africa": {
		"CountryNumber": 16,
		"Population": 320789180,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Similar to West Africa, limited connectivity.",
		"Media": {
			"Print": {"MediaNumber": "16-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "16-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "16-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Central Africa": {
		"CountryNumber": 17,
		"Population": 114085724,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Limited media makes it harder to spread.",
		"Media": {
			"Print": {"MediaNumber": "17-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "17-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "17-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Egypt": {
		"CountryNumber": 18,
		"Population": 82056398,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Religious influence makes spreading easier through certain groups.",
		"Media": {
			"Print": {"MediaNumber": "18-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "18-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "18-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"South Africa": {
		"CountryNumber": 19,
		"Population": 56534820,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Divided social groups lead to mixed adoption rates.",
		"Media": {
			"Print": {"MediaNumber": "19-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "19-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "19-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Algeria": {
		"CountryNumber": 20,
		"Population": 50094694,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Cultural barriers slow initial spread.",
		"Media": {
			"Print": {"MediaNumber": "20-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "20-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "20-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Sudan": {
		"CountryNumber": 21,
		"Population": 49260479,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Ongoing conflicts create fertile ground for conspiracy theories.",
		"Media": {
			"Print": {"MediaNumber": "21-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "21-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "21-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Morocco": {
		"CountryNumber": 22,
		"Population": 33008150,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Urban-rural divide creates varied adoption rates.",
		"Media": {
			"Print": {"MediaNumber": "22-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "22-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "22-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Madagascar": {
		"CountryNumber": 23,
		"Population": 22924851,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Geographic isolation limits initial spread but strengthens local beliefs.",
		"Media": {
			"Print": {"MediaNumber": "23-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "23-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "23-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Angola": {
		"CountryNumber": 24,
		"Population": 21471618,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Limited infrastructure slows digital spread.",
		"Media": {
			"Print": {"MediaNumber": "24-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "24-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "24-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Zimbabwe": {
		"CountryNumber": 25,
		"Population": 14149648,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Political instability makes population receptive to alternative narratives.",
		"Media": {
			"Print": {"MediaNumber": "25-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "25-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "25-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Libya": {
		"CountryNumber": 26,
		"Population": 6201521,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Political instability creates receptive environment for conspiracy theories.",
		"Media": {
			"Print": {"MediaNumber": "26-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "26-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "26-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Botswana": {
		"CountryNumber": 27,
		"Population": 2021144,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Small population but high literacy makes careful targeting necessary.",
		"Media": {
			"Print": {"MediaNumber": "27-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "27-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "27-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Russia": {
		"CountryNumber": 28,
		"Population": 160369925,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "State-controlled media limits growth but once adopted, spreads strongly.",
		"Media": {
			"Print": {"MediaNumber": "28-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "28-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "28-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Turkey": {
		"CountryNumber": 29,
		"Population": 74932641,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Political instability aids misinformation.",
		"Media": {
			"Print": {"MediaNumber": "29-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "29-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "29-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Germany": {
		"CountryNumber": 30,
		"Population": 103039718,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Highly skeptical society makes conversion tough.",
		"Media": {
			"Print": {"MediaNumber": "30-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "30-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "30-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"France": {
		"CountryNumber": 31,
		"Population": 77766807,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Strong public scrutiny makes conversion harder.",
		"Media": {
			"Print": {"MediaNumber": "31-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "31-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "31-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"UK": {
		"CountryNumber": 32,
		"Population": 68692366,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Fact-checking culture makes growth slow but effective once spread.",
		"Media": {
			"Print": {"MediaNumber": "32-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "32-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "32-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Balkan States": {
		"CountryNumber": 33,
		"Population": 62285010,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Political fragmentation creates opportunities for misinformation.",
		"Media": {
			"Print": {"MediaNumber": "33-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "33-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "33-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Italy": {
		"CountryNumber": 34,
		"Population": 59831093,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Historical conspiracies make storytelling easier.",
		"Media": {
			"Print": {"MediaNumber": "34-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "34-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "34-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Spain": {
		"CountryNumber": 35,
		"Population": 57107227,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Trust in traditional media delays spread.",
		"Media": {
			"Print": {"MediaNumber": "35-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "35-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "35-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Ukraine": {
		"CountryNumber": 36,
		"Population": 45489600,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Information warfare makes population receptive to conspiracy theories.",
		"Media": {
			"Print": {"MediaNumber": "36-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "36-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "36-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Central Europe": {
		"CountryNumber": 37,
		"Population": 44448562,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Education levels create initial resistance but can be overcome.",
		"Media": {
			"Print": {"MediaNumber": "37-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "37-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "37-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Poland": {
		"CountryNumber": 38,
		"Population": 38530725,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Traditional media still influential, slowing initial spread.",
		"Media": {
			"Print": {"MediaNumber": "38-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "38-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "38-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Baltic States": {
		"CountryNumber": 39,
		"Population": 15760118,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High digital literacy creates strong initial resistance.",
		"Media": {
			"Print": {"MediaNumber": "39-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "39-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "39-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Sweden": {
		"CountryNumber": 40,
		"Population": 9592552,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High media literacy and trust in institutions creates strong resistance.",
		"Media": {
			"Print": {"MediaNumber": "40-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "40-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "40-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Finland": {
		"CountryNumber": 41,
		"Population": 5439407,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High education levels create strong initial resistance.",
		"Media": {
			"Print": {"MediaNumber": "41-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "41-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "41-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Norway": {
		"CountryNumber": 42,
		"Population": 5084190,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High trust in institutions creates significant resistance.",
		"Media": {
			"Print": {"MediaNumber": "42-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "42-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "42-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Iceland": {
		"CountryNumber": 43,
		"Population": 323002,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Highly educated population with strong resistance to misinformation.",
		"Media": {
			"Print": {"MediaNumber": "43-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "43-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "43-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"India": {
		"CountryNumber": 44,
		"Population": 1457015015,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Rapid social media spread but high government oversight.",
		"Media": {
			"Print": {"MediaNumber": "44-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "44-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "44-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"China": {
		"CountryNumber": 45,
		"Population": 1413227603,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "High censorship makes spreading difficult, but huge population potential.",
		"Media": {
			"Print": {"MediaNumber": "45-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "45-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "45-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"S E Asia": {
		"CountryNumber": 46,
		"Population": 261600281,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Rapid adoption in urban areas; rural regions resist.",
		"Media": {
			"Print": {"MediaNumber": "46-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "46-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "46-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Indonesia": {
		"CountryNumber": 47,
		"Population": 255264831,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "Social media fuels conspiracy spread.",
		"Media": {
			"Print": {"MediaNumber": "47-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "47-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "47-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Pakistan": {
		"CountryNumber": 48,
		"Population": 182142594,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Conservative society slows spread but media can accelerate.",
		"Media": {
			"Print": {"MediaNumber": "48-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "48-2", "Visibility": "Limited", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "48-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Japan": {
		"CountryNumber": 49,
		"Population": 127338621,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Tech-savvy but skeptical society makes slow adoption.",
		"Media": {
			"Print": {"MediaNumber": "49-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "49-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "49-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Philippines": {
		"CountryNumber": 50,
		"Population": 98393574,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Social media dominance makes fast spread possible.",
		"Media": {
			"Print": {"MediaNumber": "50-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "50-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "50-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Iran": {
		"CountryNumber": 51,
		"Population": 77447168,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Censorship limits initial growth but can be subverted over time.",
		"Media": {
			"Print": {"MediaNumber": "51-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "51-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "51-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"South Korea": {
		"CountryNumber": 52,
		"Population": 75115149,
		"Followers": "0%",
		"BasicConversionPerDay": "Moderate",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Highly digital society allows for rapid social media spread.",
		"Media": {
			"Print": {"MediaNumber": "52-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "52-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "52-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"Central Asia": {
		"CountryNumber": 53,
		"Population": 49408506,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Limited media freedom but conspiracy narratives can resonate.",
		"Media": {
			"Print": {"MediaNumber": "53-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "53-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "53-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Afghanistan": {
		"CountryNumber": 54,
		"Population": 30551674,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "Limited media access but strong word-of-mouth networks.",
		"Media": {
			"Print": {"MediaNumber": "54-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "54-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "54-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"Kazakhstan": {
		"CountryNumber": 55,
		"Population": 17037508,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Controlled",
		"CountrySummary": "State media control limits initial spread but strong potential.",
		"Media": {
			"Print": {"MediaNumber": "55-1", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "55-2", "Visibility": "Moderate", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "55-3", "Visibility": "Moderate", "Installed": false, "Connected": false}
		}
	},
	"Australia": {
		"CountryNumber": 56,
		"Population": 23130900,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High media literacy but isolated communities more susceptible.",
		"Media": {
			"Print": {"MediaNumber": "56-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "56-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "56-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
	"New Guinea": {
		"CountryNumber": 57,
		"Population": 7321262,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Easy",
		"CountrySummary": "Geographic isolation makes spread difficult but local beliefs strong.",
		"Media": {
			"Print": {"MediaNumber": "57-1", "Visibility": "Late", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "57-2", "Visibility": "Late", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "57-3", "Visibility": "Late", "Installed": false, "Connected": false}
		}
	},
	"New Zealand": {
		"CountryNumber": 58,
		"Population": 4470800,
		"Followers": "0%",
		"BasicConversionPerDay": "Slow",
		"GovernmentDifficulty": "Moderate",
		"CountrySummary": "High media literacy but isolated communities more susceptible.",
		"Media": {
			"Print": {"MediaNumber": "58-1", "Visibility": "Early", "Installed": false, "Connected": false},
			"Satellite": {"MediaNumber": "58-2", "Visibility": "Early", "Installed": false, "Connected": false},
			"Social": {"MediaNumber": "58-3", "Visibility": "Early", "Installed": false, "Connected": false}
		}
	},
}

var countries = {}  # Mutable dictionary

func _init():
	# Initialize the mutable dictionary with the initial data
	countries = INITIAL_COUNTRIES.duplicate(true)
	print("✅ Countries data initialized with", countries.size(), "countries")

func _ready():
	# Verify data is loaded
	if countries.is_empty():
		push_error("❌ Countries data failed to initialize!")
	else:
		print("✅ Countries data ready with", countries.size(), "countries")

func get_country_data(country_name: String) -> Dictionary:
	var data = countries.get(country_name, {})
	if data.is_empty():
		push_error("❌ No data found for country: " + country_name)
	return data

func get_all_country_names() -> Array:
	return countries.keys()

func get_media_info(country_name: String, media_type: String) -> Dictionary:
	var country = countries.get(country_name, {})
	if country.has("Media") and country["Media"].has(media_type):
		return country["Media"][media_type]
	return {}

# Add this method to handle media installation
func set_media_installed(country_name: String, media_type: String, installed: bool) -> void:
	if countries.has(country_name) and countries[country_name]["Media"].has(media_type):
		countries[country_name]["Media"][media_type]["Installed"] = installed

# Add this method to handle media connections
func set_media_connected(country_name: String, media_type: String, connected: bool) -> void:
	if countries.has(country_name) and countries[country_name]["Media"].has(media_type):
		countries[country_name]["Media"][media_type]["Connected"] = connected

func update_followers(country_name: String, new_followers: String) -> void:
	if countries.has(country_name):
		#print("📝 Updating " + country_name + " followers from " + str(countries[country_name]["Followers"]) + " to " + new_followers)
		countries[country_name]["Followers"] = new_followers
