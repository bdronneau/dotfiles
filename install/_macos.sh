#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if ! [[ ${OSTYPE} =~ ^darwin ]]; then
    return
  fi

  defaults write com.apple.screencapture show-thumbnail -bool false
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Mouse (Magic Mouse)
  defaults write NSGlobalDomain com.apple.mouse.scaling -float 1
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string OneButton
  defaults write com.apple.AppleMultitouchMouse MouseButtonDivision -int 55
  defaults write com.apple.AppleMultitouchMouse MouseHorizontalScroll -bool true
  defaults write com.apple.AppleMultitouchMouse MouseVerticalScroll -bool true
  defaults write com.apple.AppleMultitouchMouse MouseMomentumScroll -bool true
  defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -int 0
  defaults write com.apple.AppleMultitouchMouse MouseTwoFingerDoubleTapGesture -int 3
  defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 2

  # Keyboard: U.S. International - PC as the only layout. Text Input Sources API
  # applies it live and persists it to com.apple.HIToolbox (defaults write needs a logout).
  osascript -l JavaScript - com.apple.keylayout.USInternational-PC > /dev/null << 'END_OF_KEYBOARD'
ObjC.import("Carbon");
function sources(key, value, includeAllInstalled) {
  var filter = $.NSDictionary.dictionaryWithObjectForKey($(value), $(key));
  var array = ObjC.castRefToObject($.TISCreateInputSourceList(filter, includeAllInstalled));
  var out = [];
  for (var i = 0; i < array.count; i++) out.push(array.objectAtIndex(i));
  return out;
}
function idOf(source) {
  return ObjC.castRefToObject($.TISGetInputSourceProperty(source, $.kTISPropertyInputSourceID)).js;
}
function run(argv) {
  var target = argv[0];
  var found = sources("TISPropertyInputSourceID", target, true);
  if (found.length === 0) throw new Error("keyboard layout not found: " + target);
  if ($.TISEnableInputSource(found[0]) !== 0 || $.TISSelectInputSource(found[0]) !== 0) {
    throw new Error("cannot select keyboard layout: " + target);
  }
  sources("TISPropertyInputSourceType", "TISTypeKeyboardLayout", false).forEach(function (source) {
    if (idOf(source) !== target) $.TISDisableInputSource(source);
  });
}
END_OF_KEYBOARD

  # Push mouse prefs to the running HID system without logout
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

  # Screen lock: screensaver after 2 minutes, password required 5 seconds after
  defaults -currentHost write com.apple.screensaver idleTime -int 120
  if ! grep --quiet "delay is 5 seconds" < <(sysadminctl -screenLock status 2>&1); then
    sysadminctl -screenLock 5 -password -
  fi

  defaults write com.apple.dock tilesize -int 33
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock largesize -int 61
  defaults write com.apple.dock orientation -string bottom
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock mineffect -string genie
  defaults write com.apple.dock showhidden -bool true
  killall Dock
}
