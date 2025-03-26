extends Node2D

signal day_changed(day)

@onready var country_info_panel = $"CanvasLayer/CountryInfoPanel"
@onready var country_name_label = $"CanvasLayer/CountryInfoPanel/CountryName"
@onready var population_label = $"CanvasLayer/CountryInfoPanel/Population"
@onready var resistors_label = $"CanvasLayer/CountryInfoPanel/Resistors"
@onready var followers_label = $"CanvasLayer/CountryInfoPanel/Followers"
@onready var summary_label = $"CanvasLayer/CountryInfoPanel/Summary"

@onready var countries_container = $CountriesContainer

@onready var animation_player = $CountriesContainer/AnimationPlayer

# For date calling from the DateDisplay.gd
@onready var date_display = $Calender/DateDisplay

var selected_country = null  # Track the selected country
var activation_done = false  # Prevents multiple activations

@onready var activation_button = $ActivationButton  # The activation button
@onready var activation_marker = $ActivationMarker  # The activation sprite

@onready var media_container = get_node("MediaContainer")

var button_offset := Vector2(0, -10)

var countries_data = {
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
	}
}


func _ready():
	var panel = get_tree().get_root().find_child("CountryInfoPanel", true, false)

	date_display.connect("day_changed", Callable(self, "_on_day_changed"))

	activation_button.connect("pressed", Callable(self, "_on_ActivationButton_pressed"))

	activation_marker.visible = false
	
	initialize_media_visibility()
	
	for country_name in countries_data.keys():
		var media_info = countries_data[country_name]["Media"]["Print"]
		if media_info["Visibility"] == "Early":
			activate_media(media_info["MediaNumber"], "Print")
			media_info["Installed"] = true



func _input(event):
	if event is InputEventMouseButton and event.pressed:
		check_country_click(event.position)

func check_country_click(mouse_pos):

	for country in countries_container.get_children():
		if country is Sprite2D:

			var local_pos = country.to_local(mouse_pos)

			var sprite_rect = Rect2(
				-country.texture.get_width() / 2, 
				-country.texture.get_height() / 2, 
				country.texture.get_width(), 
				country.texture.get_height()
			)

			if sprite_rect.has_point(local_pos):
				# Show country info
				update_country_info(country.name)
				play_blink_animation(country)
				_on_country_clicked(country.name, country.global_position)
				return

func update_country_info(country_name):
	if country_name in countries_data:
		var data = countries_data[country_name]

		# ✅ Update UI
		country_name_label.text = "Country: " + country_name
		population_label.text = "Population: " + str(data["Population"])
		followers_label.text = "Followers: " + str(data["Followers"]) + "%"
		summary_label.text = data["CountrySummary"]
		country_info_panel.visible = true

	else:
		print("⚠️ No data available for", country_name)


func play_blink_animation(sprite):
	animation_player.stop()  # Stop previous animations

	var anim_name = "blink_" + sprite.name  # Unique animation name per sprite

	if not animation_player.has_animation(anim_name):
		var anim = Animation.new()
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, str(sprite.get_path()) + ":modulate:a")  # Fix path issue

		# Create blink effect (fade in and out)
		anim.track_insert_key(0, 0.0, 1.0)  # Fully visible
		anim.track_insert_key(0, 0.2, 0.3)  # Almost invisible
		anim.track_insert_key(0, 0.4, 1.0)  # Fully visible
		anim.track_insert_key(0, 0.6, 0.3)  # Almost invisible
		anim.track_insert_key(0, 0.8, 1.0)  # Fully visible

		anim.length = 5.0  # Duration of 1 second

		# Add animation to an AnimationLibrary before using it
		var anim_lib = animation_player.get_animation_library("")
		if anim_lib == null:
			anim_lib = AnimationLibrary.new()
			animation_player.add_animation_library("", anim_lib)

		anim_lib.add_animation(anim_name, anim)

	animation_player.play(anim_name)

func _on_country_clicked(country_name, mouse_pos):
	if activation_done:
		print("⚠ Activation already done! Ignoring click on", country_name)
		return  

	selected_country = country_name
	
	print("✅ Country selected:", selected_country)

	# Find the country sprite dynamically
	var country_sprite = countries_container.find_child(country_name, true, false)
	if country_sprite:
		var sprite_rect = Rect2(
			-country_sprite.texture.get_width() / 2, 
			-country_sprite.texture.get_height() / 2, 
			country_sprite.texture.get_width(), 
			country_sprite.texture.get_height()
		)

		# **NEW FIX: Use center of country instead of mouse_pos**
		var center_local_pos = sprite_rect.get_center()  # Ensures we place the button at the middle
		var final_pos = country_sprite.to_global(center_local_pos)

		# Ensure button stays within country bounds
		final_pos.x = clamp(final_pos.x, country_sprite.global_position.x - sprite_rect.size.x / 2,
										   country_sprite.global_position.x + sprite_rect.size.x / 2)
		final_pos.y = clamp(final_pos.y, country_sprite.global_position.y - sprite_rect.size.y / 2,
										   country_sprite.global_position.y + sprite_rect.size.y / 2)

		# Position the activation button
		activation_button.global_position = final_pos
		activation_button.visible = true
		activation_button.mouse_filter = Control.MOUSE_FILTER_STOP
		print("✅ Activation Button Positioned at:", activation_button.global_position)
	else:
		print("❌ ERROR: Could not find sprite for", country_name)

func _on_ActivationButton_pressed():
	
	if not selected_country:
		print("⚠️ No country selected!")
		return

	if activation_done:
		print("⚠️ Activation already completed!")
		return

	print("🚀 Activating:", selected_country)

	# Hide activation button
	activation_button.visible = false
	
	date_display.start_date_timer()

	# Find country sprite & place marker
	var country_sprite = countries_container.find_child(selected_country, true, false)
	if country_sprite:
		
		var sprite_rect = Rect2(
			-country_sprite.texture.get_width() / 2, 
			-country_sprite.texture.get_height() / 2, 
			country_sprite.texture.get_width(), 
			country_sprite.texture.get_height()
		)
		
		# Place marker at the center
		var marker_position = country_sprite.to_global(sprite_rect.get_center())
		activation_marker.global_position = marker_position
		activation_marker.visible = true

		# Extra Debugging
		if not activation_marker.visible:
			print("⚠️ ERROR: Activation Marker is STILL hidden!")
		else:
			print("✅ Activation Marker is now VISIBLE!")

	else:
		print("❌ ERROR: Could not find country sprite for marker placement!")

	# Prevent multiple activations
	activation_done = true
		
func _gui_input(event):
	
	if event is InputEventMouseButton and event.pressed:
		print("🖱️ Activation Button Clicked!")
		

func schedule_media_activation(media_number, media_type, days):
	if days <= 0:
		# Activate immediately for Early visibility
		activate_media(media_number, media_type)
		return
		
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = days * 10  # Convert days to seconds
	timer.timeout.connect(func(): activate_media(media_number, media_type))
	timer.start()


func initialize_media_visibility():
	# ✅ Show Print media immediately (Early: 0 days)
	for media_category in media_container.get_children():
		if media_category.name == "Print":
			for media_node in media_category.get_children():
				media_node.visible = true  # Print media is always available at start
		else:
			for media_node in media_category.get_children():
				media_node.visible = false  # Hide other media

	print("✅ Initial Media Visibility Set (Print visible, others hidden).")

func _on_day_changed(total_days):
	print("📅 Day changed to: ", total_days)  # Debug log
	
	for country_name in countries_data.keys():
		var country_data = countries_data[country_name]
		
		for media_type in ["Satellite", "Social"]:  # Skip Print as it's handled in _ready
			if media_type in country_data["Media"]:
				var media_info = country_data["Media"][media_type]
				if not media_info["Installed"]:
					var days_needed = get_media_visibility_days(media_info["Visibility"], media_type)
					print("🔍 Checking " + media_type + " for " + country_name + 
						  " (needs " + str(days_needed) + " days, current: " + str(total_days) + ")")
					
					if total_days >= days_needed:
						activate_media(media_info["MediaNumber"], media_type)
						media_info["Installed"] = true
						print("✅ Activated " + media_type + " for " + country_name)
						
func activate_media(media_number, media_type):
	var media_category = media_container.get_node_or_null(media_type)
	if media_category:
		var media_node = media_category.get_node_or_null(str(media_number))
		if media_node:
			media_node.visible = true
			print("✅ Successfully activated " + media_type + " " + str(media_number))
		else:
			push_error("❌ ERROR: Media node not found: " + str(media_number))
	else:
		push_error("❌ ERROR: Media category not found: " + media_type)

func hide_all_media():
	for media_category in media_container.get_children():  # Loop through "Print", "Satellite", "Social"
		for media_node in media_category.get_children():  # Loop through media inside the category
			media_node.visible = false
	print("✅ All media nodes are now hidden.")

func get_media_number(country_name, media_type):
	if not countries_data.has(country_name):
		print("❌ ERROR: No country found with name", country_name)
		return ""
	
	var country_number = str(countries_data[country_name]["CountryNumber"])
	match media_type:
		"Print": return country_number + "-1"
		"Satellite": return country_number + "-2"
		"Social": return country_number + "-3"
	
	print("❌ ERROR: Invalid media type:", media_type)
	return ""

# ✅ Function to determine media visibility timing
func get_media_visibility_days(visibility, media_type):
	match visibility:
		"Early":
			return randi_range(500, 1000)  # 50-200 days
		"Moderate":
			return randi_range(1500, 3000)  # 500-1000 days
		"Late":
			return randi_range(3500, 5000)  # 1500-2500 days
		"Limited":
			return randi_range(5000, 6000)  # 3000-4000 days
	return 0
