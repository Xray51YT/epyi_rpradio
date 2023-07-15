-- Variables initialization
-- init some local variables
isMenuOpened = false
activeFrequency = 0
isRadioActive = false
isTalkingOnRadio = false
isPlayingTalkingAnim = false
animDictionary = { "cellphone@", "cellphone@in_car@ds", "cellphone@str", "random@arrests" }
animAnimation = { "cellphone_text_in", "cellphone_text_out", "cellphone_call_listen_a", "generic_radio_chatter" }
propHandle = nil
radioVolume = 100
activeFrequencyString = nil

-- Menu texture initialization
-- create the menu texture with the config parameters
if Config.MenuStyle.BannerStyle.ImageUrl ~= nil then
	local Object = CreateDui(
		Config.MenuStyle.BannerStyle.ImageUrl,
		Config.MenuStyle.BannerStyle.ImageSize.Width,
		Config.MenuStyle.BannerStyle.ImageSize.Height
	)
	_G.Object = Object
	menuTexture = "Custom_Menu_Head"
end

-- RageUI menu initialization
-- init the rageui menu with the config parameters
RMenu.Add(
	"epyi_rpradio",
	"main",
	RageUI.CreateMenu(
		_("menu_title"),
		_U("menu_subtitle"),
		Config.MenuStyle.Margins.left,
		Config.MenuStyle.Margins.top,
		menuTexture,
		menuTexture
	)
)
RMenu:Get("epyi_rpradio", "main").Closed = function()
	isMenuOpened = false
	CloseRadioMenuAnimation()
end
RMenu:Get("epyi_rpradio", "main"):SetRectangleBanner(
	Config.MenuStyle.BannerStyle.Color.r,
	Config.MenuStyle.BannerStyle.Color.g,
	Config.MenuStyle.BannerStyle.Color.b,
	Config.MenuStyle.BannerStyle.Color.a
)

---openMenu → Function to open the radio main menu
---@return void
function openMenu()
	if isMenuOpened then
		RageUI.CloseAll()
		isMenuOpened = false
		CloseRadioMenuAnimation()
	else
		isMenuOpened = true
		OpenRadioMenuAnimation()
		RageUI.Visible(RMenu:Get("epyi_rpradio", "main"), true, true, false)
		while isMenuOpened do
			exports["pma-voice"]:setVoiceProperty("micClicks", Config.Radio.Sounds.radioClicks)
			if activeFrequency == 0 then
				activeFrequencyString = _("frequency_color") .. _U("no_frequency_selected_menu")
			else
				activeFrequencyString = _("frequency_color") .. activeFrequency .. _("frequency_symbol")
			end
			RageUI.IsVisible(RMenu:Get("epyi_rpradio", "main"), true, true, true, function()
				main_showContentThisFrame()
			end)
			Citizen.Wait(1)
		end
	end
end