as3hyphenation
==============

as3-hyphenation is a partial port of the javascript library Hyphenator.js by Mathias Nater (mathias at mnn dot ch), which is also released under GNU LGPL.

Usage
-----

Step 1: Initialize hyphenation language

	Hyphenator.languages['de'] = new HyphenationPattern_DE();

Step 2: Prepare a text field

	var tf:TextField = new TextField();
	tf.text = 'Lorem Ipsum dolor....';

Step 3: Hyphenate the text field

	Hyphenator.hyphenateTextField(tf);
	
That's it!

Original copyright notice
-------------------------

Hyphenator X.Y.Z - client side hyphenation for webbrowsers 
Copyright (C) 2010  Mathias Nater, Zürich (mathias at mnn dot ch)
Project and Source hosted on http://code.google.com/p/hyphenator/