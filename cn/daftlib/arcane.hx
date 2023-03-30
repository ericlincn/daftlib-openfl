package cn.daftlib;

//public namespace arcane

/*
http://haxe.org/manual/types-structure-performance.html
http://haxe.org/manual/types-abstract.html
http://haxe.org/manual/type-system-generic.html
http://haxe.org/manual/class-field-property-rules.html
http://haxe.org/manual/class-field-inline.html
http://haxe.org/manual/expression-new.html
http://haxe.org/manual/lf-pattern-matching.html
http://haxe.org/manual/lf-array-comprehension.html
http://haxe.org/manual/lf-function-bindings.html
http://haxe.org/manual/macro.html
http://haxe.org/manual/std-serialization.html

http://haxe.org/manual/cr-metadata.html
http://haxe.org/manual/lf-access-control.html
http://haxe.org/manual/lf-inline-constructor.html
http://haxe.org/manual/std-vector.html
http://haxe.org/manual/std-List.html
http://haxe.org/manual/std-GenericStack.html
http://haxe.org/manual/std-Map.html
http://haxe.org/manual/std-Lambda.html
http://haxe.org/manual/std-template.html
http://haxe.org/manual/target-javascript-expose.html
	
https://github.com/jdonaldson/learnxinyminutes-docs/blob/master/haxe.html.markdown
	
embed fonts: (NOT AVAILABLE IN HTML5)
	1.before class:
	@:font("../../../assets/xxx.ttf") class DefaultFont extends Font {}
	2.in class:
	Font.registerFont(DefaultFont);
	FontLibrary.getRegistedFonts();
@:bitmap (extends BitmapData)
@:file (extends ByteArray)
@:sound (extends Sound)
@:noCompletion : does not list the field as part of compiler completion results (since 3.0)
@:final : the given class cannot be subclassed anymore
@:allow(my.pack) : This will give access to all private fields of a class to all the classes in the package my.pack (and its sub-packages).(since 3.0)
etc: @:allow(cn.daftlib.core.IRemovableEventDispatcher)
@:access
@:setter (flash only)
When override flash setter, return value is Void.
etc: @:setter(endian) function set_endian(endian:String):Void{}
	
MouseEvent.CLICK does not working in html5, using MouseEvent.MOUSE_UP instead.
If wanna Dynamic be Keys, using cn.daftlib.data.DynamicDictionary instead of Dictionary.
html5 play sound:
	in Android, call Sound.play() after sound loaded.
	in iOS, using MouseEvent to load and play a short sound, before play the other sound.
	function downHandler(e:Event):Void
	{
		var snd:Sound = new Sound();
		snd.load(new URLRequest("snd/short.mp3"));
		snd.play();
		
		if(__played == false)
		{
			__played = true;
			TweenManager.delayCall(1/60, playSong);
		}
	}
DaftVideo is waiting openfl video support
Multistate
	Create = 0x00 << 0;
	Read   = 0x01 << 1;
	Update = 0x01 << 2;
	Delete = 0x00 << 3;
	currentState = Delete|Update|Read|Create;
Math.fceil, Math.ffloor, Math.fround for Float>32bit

Add <haxeflag name="-dce full" /> in application.xml to reduce weight of js file
<window orientation="portrait" />
<!-- <window orientation="landscape" /> -->
<window background="#000000" fps="60" hardware="true" allow-shaders="true" require-shaders="true" depth-buffer="true" stencil-buffer="true" />
Custom preloader
<app preloader="cn.daftlib.templates.Preloader" />
Custom Android permission
<template path="../../daftlib/haxe/daftlib/cn/daftlib/templates/AndroidManifest.xml" rename="AndroidManifest.xml" if="android" />
Custom Application entry point
<template path="../../daftlib/haxe/daftlib/cn/daftlib/templates/ApplicationMain.hx" rename="../haxe/ApplicationMain.hx" if="html5" />
Add daftlib
<source path="../../daftlib/haxe/daftlib" />

Sign android app for release
	1.Create a Keystore / Certificate
	Requires keytool part of the Java JDK (For me found in C:\Development\Java JDK\bin):
	keytool -genkey -v -keystore "my_android_certificate.keystore" -alias my_games_android -keyalg RSA -keysize 2048 -validity 10000
	Will ask for passwords, and information about your name and your organisation.

	2.Edit the OpenFL application.xml to use the certificate:
	<!-- certificates -->
	<certificate path="certificates/my_android_certificate.keystore" alias="my_games_android" password="<password>" if="android" ></certificate>
	The password field is optional, saves having to enter it from the command line. Important in my instance so my build machine can produce a signed APK file for me.
*/