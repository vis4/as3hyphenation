/*
 * as3-hyphenation - hyphenation for flash
 * Copyright (C) 2010  Gregor Aisch (gka at vis4 dot net)
 * Project and Source hosted on http://bitbucket.org/gka/as3-hyphenation/
 * 
 * This ActionScript code is free software: you can redistribute it 
 * and/or modify it under the terms of the GNU Lesser General Public 
 * License (GNU LGPL) as published by the Free Software Foundation, 
 * either version 3 of the License, or (at your option) any later version.
 * 
 * This code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * as3-hyphenation is a partial port of the javascript library 
 * Hyphenator.js by Mathias Nater (mathias at mnn dot ch), which is
 * also released under GNU LGPL.
 *
 * Hyphenator X.Y.Z - client side hyphenation for webbrowsers
 * Copyright (C) 2010  Mathias Nater, Zürich (mathias at mnn dot ch)
 * Project and Source hosted on http://code.google.com/p/hyphenator/
 */
package net.vis4.text.hyphenation 
{
	import adobe.utils.ProductManager;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.*;
	import net.vis4.text.hyphenation.patterns.*;
	import net.vis4.utils.HtmlParser;
	import org.osflash.thunderbolt.Logger;
	
	public class Hyphenator
	{
		// commenting out unneeded languages will reduce your swf filesize
		public static var languages:Object = {
			/*'cs': new HyphenationPattern_CS(),
			'da': new HyphenationPattern_DA(), 
			'de': new HyphenationPattern_DE(),
			'en': new HyphenationPattern_EN(),
			'es': new HyphenationPattern_ES(),
			'fi': new HyphenationPattern_FI(),
			'fr': new HyphenationPattern_FR(),
			'gu': new HyphenationPattern_GU(),
			'hi': new HyphenationPattern_HI(),
			//'hu': new HyphenationPattern_HU(),
			'hy': new HyphenationPattern_HY(),
			'it': new HyphenationPattern_IT(),
			'lt': new HyphenationPattern_LT(),
			'nl': new HyphenationPattern_NL(),
			'pt': new HyphenationPattern_PT(),
			'ru': new HyphenationPattern_RU(),
			'sl': new HyphenationPattern_SL(),
			'sv': new HyphenationPattern_SV(),
			'ta': new HyphenationPattern_TA(),
			'te': new HyphenationPattern_TE(),
			'tr': new HyphenationPattern_TR(),
			'uk': new HyphenationPattern_UK()//*/
		}
		
		/**
		 * @name Hyphenator-enableCache
		 * @fieldOf Hyphenator
		 * @description
		 * A variable to set if caching is enabled or not
		 * @type boolean
		 * @default true
		 * @private
		 * @see Hyphenator.config
		 * @see hyphenateWord
		 */		
		public static var enableCache:Boolean = true;
		
		/**
		 * @name Hyphenator-enableReducedPatternSet
		 * @fieldOf Hyphenator
		 * @description
		 * A variable to set if storing the used patterns is set
		 * @type boolean
		 * @default false
		 * @private
		 * @see Hyphenator.config
		 * @see hyphenateWord
		 * @see Hyphenator.getRedPatternSet
		 */			
		public static var enableReducedPatternSet:Boolean = false;
		
		/**
		 * @name Hyphenator-exceptions
		 * @fieldOf Hyphenator
		 * @description
		 * An object containing exceptions as comma separated strings for each language.
		 * When the language-objects are loaded, their exceptions are processed, copied here and then deleted.
		 * @see Hyphenator-prepareLanguagesObj
		 * @type object
		 * @private
		 */	
		public static var exceptions:Object = { };
		
		/**
		 * @name Hyphenator-min
		 * @fieldOf Hyphenator
		 * @description
		 * A number wich indicates the minimal length of words to hyphenate.
		 * @type number
		 * @default 6
		 * @private
		 * @see Hyphenator.config
		 */	
		public static var min:int = 5;		
		
		/**
		 * @name Hyphenator-url
		 * @fieldOf Hyphenator
		 * @description
		 * A string containing a RegularExpression to match URL's
		 * @type string
		 * @private
		 */	
		public static var url:String = '(\\w*:\/\/)?((\\w*:)?(\\w*)@)?((([\\d]{1,3}\\.){3}([\\d]{1,3}))|((www\\.|[a-zA-Z]\\.)?[a-zA-Z0-9\\-\\.]+\\.([a-z]{2,4})))(:\\d*)?(\/[\\w#!:\\.?\\+=&%@!\\-]*)*';
		//                              protocoll     usr     pwd                    ip               or                          host                 tld        port               path
		
		/**
		 * @name Hyphenator-mail
		 * @fieldOf Hyphenator
		 * @description
		 * A string containing a RegularExpression to match mail-adresses
		 * @type string
		 * @private
		 */	
		public static var mail:String = '[\\w-\\.]+@[\\w\\.]+';
		
		/**
		 * @name Hyphenator-urlRE
		 * @fieldOf Hyphenator
		 * @description
		 * A RegularExpressions-Object for url- and mail adress matching
		 * @type object
		 * @private
		 */		
		public static var urlOrMailRE:RegExp = new RegExp('(' + url + ')|(' + mail + ')', 'i');
		
		/**
		 * @name Hyphenator-hyphen
		 * @fieldOf Hyphenator
		 * @description
		 * A string containing the character for in-word-hyphenation
		 * @type string
		 * @default the soft hyphen
		 * @private
		 * @see Hyphenator.config
		 */
		public static var hyphen:String = '-';
		
		/**
		 * @name Hyphenator-urlhyphen
		 * @fieldOf Hyphenator
		 * @description
		 * A string containing the character for url/mail-hyphenation
		 * @type string
		 * @default the zero width space
		 * @private
		 * @see Hyphenator.config
		 * @see Hyphenator-zeroWidthSpace
		 */
		public static var urlhyphen:String = String.fromCharCode(8203);		
		
		/**
		 * @name Hyphenator-prepareLanguagesObj
		 * @methodOf Hyphenator
		 * @description
		 * Adds a cache to each language and converts the exceptions-list to an object.
		 * @private
		 * @param string the language ob the lang-obj
		 */		
		public static function prepareLanguagesObj(lang:String):void 
		{
			var lo:Object = Hyphenator.languages[lang], wrd:String;
			if (!lo.prepared) {	
				if (enableCache) {
					lo.cache = {};
				}
				if (enableReducedPatternSet) {
					lo.redPatSet = {};
				}
				if (lo.exceptionsString != '') {
					Hyphenator.addExceptions(lang, lo.exceptionsString);
				}
			
				if (exceptions.hasOwnProperty('global')) {
					if (exceptions.hasOwnProperty(lang)) {
						exceptions[lang] += ', ' + exceptions.global;
					} else {
						exceptions[lang] = exceptions.global;
					}
				}
				/*if (exceptions.hasOwnProperty(lang)) {
					lo.exceptions = convertExceptionsToObject(exceptions[lang]);
					exceptions[lang] = null;
				} else {
					lo.exceptions = {};
				}*/
				lo.exceptions = { };
				convertPatterns(lang);
				wrd = '[\\w' + lo.specialChars + '@' + String.fromCharCode(173) + '-]{' + min + ',}';
				
				lo.genRegExp = new RegExp('(' + url + ')|(' + mail + ')|(' + wrd + ')', 'gi');
				lo.prepared = true;
			}
			
		}		
		
		/**
		 * @name Hyphenator.addExceptions
		 * @methodOf Hyphenator
		 * @description
		 * Adds the exceptions from the string to the appropriate language in the 
		 * {@link Hyphenator-languages}-object
		 * @param string The language
		 * @param string A comma separated string of hyphenated words WITH spaces.
		 * @public
		 * @example &lt;script src = "Hyphenator.js" type = "text/javascript"&gt;&lt;/script&gt;
         * &lt;script type = "text/javascript"&gt;
         *   Hyphenator.addExceptions('de','ziem-lich, Wach-stube');
         *   Hyphenator.run();
         * &lt;/script&gt;
         */
		public static function addExceptions(lang:String, words:String ):void {
			if (lang === '') {
				lang = 'global';
			}
			if (exceptions.hasOwnProperty(lang)) {
				exceptions[lang] += ", " + words;
			} else {
				exceptions[lang] = words;
			}
		}
		
		
		/**
		 * @name Hyphenator-convertExceptionsToObject
		 * @methodOf Hyphenator
		 * @description
		 * Converts a list of comma seprated exceptions to an object:
		 * 'Fortran,Hy-phen-a-tion' -> {'Fortran':[],'Hyphenation':[2,6,7]'}
		 * @private
		 * @param string a comma separated string of exceptions (without spaces)
		 */		
		public static function convertExceptionsToObject (exc:String):Object 
		{
			var w:Array = exc.split(', '),
				r:Object = {}, hypos:Array, k:int,
				i:int, l:int, key:String;
			for (i = 0, l = w.length; i < l; i++) {
				key = w[i].replace(/-/g, '');
				k = 0; hypos = [];
				while ((k = w[i].indexOf('-', k+1)) > -1) hypos.push(k);
				if (!r.hasOwnProperty(key)) {
					r[key] = hypos;
				}
			}
			return r;
		}		
		
		/**
		 * @name Hyphenator-convertPatterns
		 * @methodOf Hyphenator
		 * @description
		 * Converts the patterns from string '_a6' to object '_a':'_a6'.
		 * The result is stored in the {@link Hyphenator-patterns}-object.
		 * @private
		 * @param string the language whose patterns shall be converted
		 */		
		protected static function convertPatterns(lang:String):void 
		{
			var plen:String, pleni:int, anfang:int, ende:int, pats:Object, pat:String, key:String, tmp:Object = {};
			pats = languages[lang].patterns;
			for (plen in pats) {
				if (pats.hasOwnProperty(plen)) {
					pleni = parseInt(plen, 10);
					anfang = 0;
					ende = pleni;
					while (!!(pat = pats[plen].substring(anfang, ende))) {
						key = pat.replace(/\d/g, '');
						tmp[key] = pat;
						anfang = ende;
						ende += pleni;
					}
				}
			}
			languages[lang].patterns = tmp;
			languages[lang].patternsConverted = true;
		}		

		/**
		 * @name Hyphenator-hyphenateWord
		 * @methodOf Hyphenator
		 * @description
		 * This function is the heart of Hyphenator.js. It returns a hyphenated word.
		 *
		 * If there's already a {@link Hyphenator-hypen} in the word, the word is returned as it is.
		 * If the word is in the exceptions list or in the cache, it is retrieved from it.
		 * If there's a '-' put a zeroWidthSpace after the '-' and hyphenate the parts.
		 * @param string The language of the word
		 * @param string The word
		 * @returns array Array of possible hyphon positions inside this word
		 * @public
		 */		
		public static function hyphenateWord(lang:String, word:String):Array
		{
			var lo:Object = languages[lang],
				parts:Array, i:int, j:int, w:String, wl:uint, s:Array, hypos:Array, p:uint, maxwins:uint, 
				win:uint, pat:*, patk:String, c:int, t:int, n:int, l:uint, 
				numb3rs:Object, inserted:int, hyphenatedword:String, val:Array;
			
			
				
			if (word == '') {
				return [];
			}
			/*if (word.indexOf(hyphen) != -1) {
				//word already contains shy; -> leave at it is!
				return word;
			}*/
			if (enableCache && lo.cache.hasOwnProperty(word)) { //the word is in the cache
				return lo.cache[word];
			}
			if (lo.exceptions.hasOwnProperty(word)) { //the word is in the exceptions list
				return lo.exceptions[word];
			}
			/*if (word.indexOf('-') !== -1) {
				//word contains '-' -> hyphenate the parts separated with '-'
				parts = word.split('-');
				for (i = 0, l = parts.length; i < l; i++) {
					parts[i] = hyphenateWord(lang, parts[i]);
				}
				return parts.join('-');
			}*/
			
			
			
			//finally the core hyphenation algorithm
			w = '_' + word + '_';
			wl = w.length;
			s = w.split('');
			w = w.toLowerCase();
			hypos = [];
			numb3rs = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}; //check for member is faster then isFinite()
			n = wl - lo.shortestPattern;
						
			for (p = 0; p <= n; p++) {
				maxwins = Math.min((wl - p), lo.longestPattern); 
				for (win = lo.shortestPattern; win <= maxwins; win++) { 
					patk = w.substring(p, p + win); 
					//trace('[Hyphenator] patk = '+patk);
					if (lo.patterns.hasOwnProperty(patk)) {
						pat = lo.patterns[patk];
						//trace('[Hyphenator] pat.length = '+pat.length);
						if (enableReducedPatternSet) {
							lo.redPatSet[patk] = pat;
						}
						if (pat is String) {
							//convert from string 'a5b' to array [1,5] (pos,value)
							t = 0;
							val = [];
							
							for (i = 0; i < pat.length; i++) {
								if (!isNaN(c = numb3rs[pat.charAt(i)])) {
									val.push(i - t, c);
									t++;								
								}
							}
							pat = lo.patterns[patk] = val;
						}
					} else {
						continue;
					}
					for (i = 0; i < pat.length; i++) {
						c = p - 1 + pat[i];
						if (!hypos[c] || hypos[c] < pat[i+1]) {
							hypos[c] = pat[i+1];
						}
						i++;
					}
				}
			}	
			inserted = 0;
			var hyphonPositions:Array = [];
			for (i = lo.leftmin; i <= (word.length - lo.rightmin); i++) {
				if (!!(hypos[i] & 1)) {
					//s.splice(i + inserted + 1, 0, hyphen);
					inserted++;
					hyphonPositions.push(i);
				}
			}
			//trace(hyphonPositions);
			
			//hyphenatedword = s.slice(1, -1).join('');
			if (enableCache) {
				lo.cache[word] = hyphonPositions;
			}
			
			return hyphonPositions;

		}
		
		/**
		 * @name Hyphenator-hyphenateURL
		 * @methodOf Hyphenator
		 * @description
		 * Puts {@link Hyphenator-urlhyphen} after each no-alphanumeric char that my be in a URL.
		 * @param string URL to hyphenate
		 * @returns string the hyphenated URL
		 * @public
		 */
		public static function hyphenateURL(url:String):String {
			return url.replace(/([:\/\.\?#&_,;!@]+)/gi, '$&' + urlhyphen);
		}	
		
		protected static function hyphenate(lang:String, word:String):Array
		{
			if (urlOrMailRE.test(word)) {
				return []; // hyphenateURL(word);
			} else {
				return hyphenateWord(lang, word);
			}
		}
		
		public static function hyphenateTextField(lang:String, tf:TextField):void
		{
			if (Hyphenator.languages.hasOwnProperty(lang)) {
				if (!Hyphenator.languages[lang].prepared) {
					prepareLanguagesObj(lang);
				}
			} else {
				//throw new Error('language ' + lang + ' is unknown');
				return;
			}
			
			if (tf.styleSheet != null) {
				hyphenateHTMLTextField(lang, tf);
				return;
			}
			
			var p:int, lo:Object = languages[lang];
			var txt:String = tf.text, words:Array, delimiters:Array, word:String, delim:String, l:int, old:String, parts:Array, splitpos:uint;
			var spl:Object, w:int, hypos:Array;
			
			
			if (txt.length > min) {
				
				spl = splitText(lang, txt);
				words = spl.words;
				delimiters = spl.delim;
				
				tf.text = '';
				l = tf.numLines; 
				
				for (w = 0; w < words.length; w++) {
					word = words[w];
					
					delim = delimiters.length > w ? delimiters[w] : '';
					
					splitpos = 0;
					// store current text
					old = tf.text;
						
					if (word != '' && lo.genRegExp.test(word) || lo.genRegExp.test(word)) {
						
						// try adding this word to see if we break into a new line
						tf.appendText(word + delim);

						if (tf.numLines > l) {
							// yes, we break into a new line
							tf.text = old; // reset old text
							
							if (words.length == 1 || w < words.length-1) { // don't hyphenate the last word, looks ugly
								hypos = hyphenate(lang, word);
								
								if (hypos.length > 0) {
									
									for (p = hypos.length - 1; p >= 0; p--) {
										
										tf.text = old + word.substr(0, hypos[p]) + hyphen;
										
										if (tf.numLines == l) {
											splitpos = hypos[p];
											break;
										}
									}
								} 
							}
							l = tf.numLines;
						}
					} 
					
					if (splitpos > 0) {
						tf.text = old + word.substr(0, splitpos) + hyphen + word.substr(splitpos) + delim;
					} else {
						tf.text = old + word + delim;
					}
				}
			}
		}
		
		static public function hyphenateText(text:String, lang:String, tfmt:TextFormat, maxWidth:Number, embedFonts:Boolean= true):String
		{
			var tf:TextField = new TextField();
			tf.embedFonts = embedFonts;
			tf.defaultTextFormat = tfmt;
			tf.wordWrap = true;
			tf.width = maxWidth;
			tf.text = text;
			
			hyphenateTextField(lang, tf);
			return tf.text;
		}
		
		static private function hyphenateHTMLTextField(lang:String, tf:TextField):void
		{
			_openTags = [];
			_curLang = lang;
			_curTextField = tf;
			_prependHtml = '';
			new HtmlParser().Parse(tf.htmlText, { 
				start: __openTag, end: __closeTag, chars: __tagContent, comment: __comment
			} );
			tf.htmlText = _prependHtml;
		}
		
		/*
		 * PARSER FUNCTIONS 
		 */
		
		static private var _openTags:Array;
		static private var _prependHtml:String;
		static private var _curLang:String;
		static private var _curTextField:TextField;
		 
		static private function __openTag(tag:String, attrs:Array, unary:Boolean):void
		{
			if (!unary) _openTags.push(tag);
			_prependHtml += '<' + tag;
			
			for ( var i:int = 0; i < attrs.length; i++ )
				_prependHtml += " " + attrs[i].name + '="' + attrs[i].escaped + '"';
			_prependHtml += ">";
			if (unary) _prependHtml += '</' + tag + '>';
		}
		
		static private function __closeTag(tag:String):void
		{
			if (_openTags.pop() != tag) throw new Error('invalid html');
			_prependHtml += '</' + tag + '>';
		}
		
		static private function __tagContent(text:String):void
		{
			var closingTags:String = '';
			for each (var tag:String in _openTags) closingTags = '</' + tag + '>' + closingTags;
			
			//trace(text, closingTags);
			var res:String = hyphenatePart(_curLang, _curTextField, text, _prependHtml, closingTags);

			_prependHtml += res;
		}
		
		static private function __comment(text:String):void
		{
			_prependHtml += '<!--' + text + '-->';
		}
		
		static private function hyphenatePart(lang:String, tf:TextField, txt:String, prependHtml:String, appendHtml:String):String
		{
			var p:int, lo:Object = languages[lang], innerHTML:String;
			var words:Array, delimiters:Array, word:String, delim:String, l:int, old:String, parts:Array, splitpos:uint;
			var spl:Object, w:int, hypos:Array;
			
			if (txt.length > min) { 
				
				spl = splitText(lang, txt);
				words = spl.words;
				delimiters = spl.delim;
				
				innerHTML = '';
				tf.htmlText = prependHtml + innerHTML + appendHtml;
				l = tf.numLines;
						
				for (w = 0; w < words.length; w++) {
					word = words[w];
					
					delim = delimiters.length > w ? delimiters[w] : '';
					
					splitpos = 0;		
						
					if (word != '' && lo.genRegExp.test(word) || lo.genRegExp.test(word)) {
						
						// try adding this word to see if we break into a new line
						tf.htmlText = prependHtml + innerHTML + word + delim + appendHtml;
												
						if (tf.numLines > l) {
							// yes, we break into a new line
							// tf.text = prependHtml + innerHTML + appendHtml;; // reset old text
							hypos = hyphenate(lang, word);
							
							if (hypos.length > 0) {
								
								for (p = hypos.length - 1; p >= 0; p--) {
									
									tf.htmlText = _prependHtml + innerHTML + word.substr(0, hypos[p]) + hyphen + appendHtml;
									
									if (tf.numLines == l) {
										splitpos = hypos[p];
										break;
									}
								}
							} 
							
							l = tf.numLines;
						}
					} 
					
					if (splitpos > 0) {
						innerHTML += word.substr(0, splitpos) + hyphen + word.substr(splitpos) + delim;
					} else {
						innerHTML += word + delim;
					}
				}
				
			} else return txt;
			
			return innerHTML;
		}
		
		
		public static function splitText(lang:String, text:String):Object
		{
			var lo:Object = languages[lang], i:int, words:Array, delim:Array;
			var letters:String = 'abcdefghijklmnopqrstuvwxyz' + lo.specialChars, word:String;
			
			words = [];
			delim = [];
			word = '';
			
			for (i = 0; i < text.length; i++) {
				if (letters.indexOf(text.charAt(i).toLowerCase()) >= 0) {
					word += text.charAt(i);
				} else {
					words.push(word);
					delim.push(text.charAt(i));
					word = '';
				}
			}
			if (word != '') words.push(word);
			return { words: words, delim: delim };
			
		}
		
	}

}