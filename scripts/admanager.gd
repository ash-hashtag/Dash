extends Node


var rewarded_interstitial_ad : RewardedInterstitialAd
var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()

var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()

var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()

func _ready():
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = _print_ad_error
	rewarded_interstitial_ad_load_callback.on_ad_loaded = _on_rewarded_interstitial_ad_loaded

	interstitial_ad_load_callback.on_ad_failed_to_load = _print_ad_error
	interstitial_ad_load_callback.on_ad_loaded = _on_interstitial_ad_loaded

	rewarded_ad_load_callback.on_ad_failed_to_load = _print_ad_error
	rewarded_ad_load_callback.on_ad_loaded = _on_rewarded_ad_loaded

	print("Is using test ads? : ", OS.is_debug_build())
	var callback = OnInitializationCompleteListener.new()
	callback.on_initialization_complete = _on_init
	MobileAds.initialize(callback)

func _on_init(status):
	print("Admob initialized ", str(status))
	load_ads()

func load_ads():
	print("Loading Ads")
	_load_banner_ad()
	_load_interstitial_ad()
	_load_rewarded_interstitial_ad()
	_load_rewarded_ad()


enum AdType {
	Banner = 0,
	Interstitial = 1,
	InterstitialVideo = 2,
	Rewarded = 3,
	RewardedInterstitial = 4
}

const testing_ad_units := [
	"ca-app-pub-3940256099942544/6300978111", # banner
	"ca-app-pub-3940256099942544/1033173712", # interstitial
	"ca-app-pub-3940256099942544/8691691433", # interstitial video
	"ca-app-pub-3940256099942544/5224354917", # rewarded
	"ca-app-pub-3940256099942544/5354046379" # rewarded interstitial
	]
const production_ad_units := [
	"ca-app-pub-6050025830397443/5543897689",
	"ca-app-pub-6050025830397443/1900166142",
	"ca-app-pub-6050025830397443/1900166142",
	"ca-app-pub-6050025830397443/7950569175",
	"ca-app-pub-6050025830397443/7859069839",
]

func _get_ad_unit(ad_type: AdType) -> String:
	if OS.is_debug_build(): 
		return testing_ad_units[ad_type]
	else:
		return production_ad_units[ad_type]


func _load_rewarded_ad() -> void:
	var unit_id = _get_ad_unit(AdType.Rewarded)
	RewardedAdLoader.new().load(unit_id, _new_ad_request(), rewarded_ad_load_callback)

func _load_rewarded_interstitial_ad() -> void:
	var unit_id := _get_ad_unit(AdType.RewardedInterstitial)
	RewardedInterstitialAdLoader.new().load(unit_id, _new_ad_request(), rewarded_interstitial_ad_load_callback)

func _print_ad_error(adError: LoadAdError) -> void:
	printerr(adError.message)

func _on_rewarded_interstitial_ad_loaded(ad : RewardedInterstitialAd) -> void:
	if rewarded_interstitial_ad:
		rewarded_interstitial_ad.destroy()
	self.rewarded_interstitial_ad = ad

func _on_rewarded_ad_loaded(ad : RewardedAd) -> void:
	if rewarded_ad:
		rewarded_ad.destroy()
	self.rewarded_ad = ad

func _on_interstitial_ad_loaded(ad : InterstitialAd) -> void:
	if interstitial_ad:
		interstitial_ad.destroy()
	self.interstitial_ad = ad

func _load_banner_ad():
	var unit_id := _get_ad_unit(AdType.Banner)
	var ad_view := AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.BOTTOM)
	ad_view.load_ad(_new_ad_request())
	print("Loading Banner Ad")

func _load_interstitial_ad():
	var unit_id := _get_ad_unit(AdType.Interstitial if randf() > 0.5 else AdType.InterstitialVideo)
	InterstitialAdLoader.new().load(unit_id, _new_ad_request(), interstitial_ad_load_callback)

func show_rewarded_interstitial_ad(on_user_earned_reward_listener: OnUserEarnedRewardListener):
	if rewarded_interstitial_ad:
		rewarded_interstitial_ad.show(on_user_earned_reward_listener)
	#_load_rewarded_interstitial_ad()

func show_interstitial_ad():
	print("Showing Interstitial Ad")
	if interstitial_ad:
		interstitial_ad.show()
	#_load_interstitial_ad()

func show_rewarded_ad(on_user_earned_reward_listener: OnUserEarnedRewardListener):
	print("Showing Rewarded Ad")
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
	#_load_rewarded_ad()

func _new_ad_request() -> AdRequest:
	var ad = AdRequest.new()
	#ad.extras["max_ad_content_rating"] = "G"
	return ad


func _on_timer_timeout():
	load_ads()
