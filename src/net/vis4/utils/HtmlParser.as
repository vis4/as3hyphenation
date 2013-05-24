﻿/*
 * 14th May 2009: The following was adapted to ActionScript 3.0 by Gary McGhee of Buzzware Solutions (email gary at buzzware . com . au)
 *
 * HTML Parser By John Resig (ejohn.org)
 * Original code by Erik Arvidsson, Mozilla Public License
 * http://erik.eae.net/simplehtmlparser/simplehtmlparser.js
 *
 * // Use like so:
 * Parse(htmlString, {
 *     start: function(tag, attrs, unary) {},
 *     end: function(tag) {},
 *     chars: function(text) {},
 *     comment: function(text) {}  
 * });
 *
 * // or to get an XML string:
 * HTMLtoXML(htmlString);
 *
 * // or to get an XML DOM Document
 * HTMLtoDOM(htmlString);
 *
 * // or to inject into an existing document/DOM node
 * HTMLtoDOM(htmlString, document);
 * HTMLtoDOM(htmlString, document.body);
 *
 */
package net.vis4.utils 
{
	import adobe.utils.CustomActions;

	public class HtmlParser {
	
		// Regular Expressions for parsing tags and attributes
		private var startTag:RegExp = /^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/,
			endTag:RegExp = /^<\/(\w+)[^>]*>/,
			attr:RegExp = /(\w+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?/g;
			
		// Empty Elements - HTML 4.01
		private var empty:Object = makeMap("area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed");
	
		// Block Elements - HTML 4.01
		private var block:Object = makeMap("address,applet,blockquote,button,center,dd,del,dir,div,dl,dt,fieldset,form,frameset,hr,iframe,ins,isindex,li,map,menu,noframes,noscript,object,ol,p,pre,script,table,tbody,td,tfoot,th,thead,tr,ul");
	
		// Inline Elements - HTML 4.01
		private var inline:Object = makeMap("a,abbr,acronym,applet,b,basefont,bdo,big,br,button,cite,code,del,dfn,em,font,i,iframe,img,input,ins,kbd,label,map,object,q,s,samp,script,select,small,span,strike,strong,sub,sup,textarea,tt,u,var");
	
		// Elements that you can, intentionally, leave open
		// (and which close themselves)
		private var closeSelf:Object = makeMap("colgroup,dd,dt,li,options,p,td,tfoot,th,thead,tr");
	
		// Attributes that have their values filled in disabled="disabled"
		private var fillAttrs:Object = makeMap("checked,compact,declare,defer,disabled,ismap,multiple,nohref,noresize,noshade,nowrap,readonly,selected");
	
		// Special Elements (can contain anything)
		private var special:Object = makeMap("script,style");
	
		/**
		 * 
		 * handler: {
		 *     start: function(tag, attrs, unary) {},
		 *     end: function(tag) {},
		 *     chars: function(text) {},
		 *     comment: function(text) {}  
		 * }
		 * 
		 * @param	html
		 * @param	handler
		 */
		public function Parse(html:String, handler:Object ):void 
		{
			var index:int, chars:Boolean, match:Array, stack:Array = [], last:String = html;
			
			stack.last = function():*{
				return this[ this.length - 1 ];
			};
	
			while ( html ) {
				chars = true;
	
				// Make sure we're not in a script or style element
				if ( !stack.last() || !special[ stack.last() ] ) {
	
					// Comment
					if ( html.indexOf("<!--") == 0 ) {
						index = html.indexOf("-->");
		
						if ( index >= 0 ) {
							if ( handler.comment )
								handler.comment( html.substring( 4, index ) );
							html = html.substring( index + 3 );
							chars = false;
						}
		
					// end tag
					} else if ( html.indexOf("</") == 0 ) {
						match = html.match( endTag );
		
						if ( match ) {
							html = html.substring( match[0].length );
							match[0].replace( endTag, parseEndTag );
							chars = false;
						}
		
					// start tag
					} else if ( html.indexOf("<") == 0 ) {
						match = html.match( startTag );
		
						if ( match ) {
							html = html.substring( match[0].length );
							match[0].replace( startTag, parseStartTag );
							chars = false;
						}
					}
	
					if ( chars ) {
						index = html.indexOf("<");
						
						var text:String = index < 0 ? html : html.substring( 0, index );
						html = index < 0 ? "" : html.substring( index );
						
						if ( handler.chars )
							handler.chars( text );
					}
	
				} else {
					html = html.replace(new RegExp("(.*)<\/" + stack.last() + "[^>]*>"), function(all:String, text:String):String{
						text = text.replace(/<!--(.*?)-->/g, "$1")
							.replace(/<!\[CDATA\[(.*?)]]>/g, "$1");
	
						if ( handler.chars )
							handler.chars( text );
	
						return "";
					});
	
					parseEndTag( "", stack.last() );
				}
	
				if ( html == last )
					throw "Parse Error: " + html;
				last = html;
			}
			
			// Clean up any remaining tags
			parseEndTag();
	
			function parseStartTag( tag:*, tagName:String, rest:String, unary:Boolean, ...arguments ):void {
				if ( block[ tagName ] ) {
					while ( stack.last() && inline[ stack.last() ] ) {
						parseEndTag( "", stack.last() );
					}
				}
	
				if ( closeSelf[ tagName ] && stack.last() == tagName ) {
					parseEndTag( "", tagName );
				}
	
				unary = empty[ tagName ] || !!unary;
	
				if ( !unary )
					stack.push( tagName );
				
				if ( handler.start ) {
					var attrs:Array = [];
		
					rest.replace(attr, function(match:String, name:String):void {
						var value:String = arguments[2] ? arguments[2] :
							arguments[3] ? arguments[3] :
							arguments[4] ? arguments[4] :
							fillAttrs[name] ? name : "";
						
						attrs.push({
							name: name,
							value: value,
							escaped: value.replace(/(^|[^\\])"/g, '$1\\\"') //"
						});
					});
		
					if ( handler.start )
						handler.start( tagName, attrs, unary );
				}
			}
	
			function parseEndTag( tag:* = null, tagName:* = false, ...arguments ):void {
				// If no tag name is provided, clean shop
				if ( !tagName )
					var pos:int = 0;
					
				// Find the closest opened tag of the same type
				else
					for ( pos = stack.length - 1; pos >= 0; pos-- )
						if ( stack[ pos ] == tagName )
							break;
				
				if ( pos >= 0 ) {
					// Close all the open elements, up the stack
					for ( var i:int = stack.length - 1; i >= pos; i-- )
						if ( handler.end )
							handler.end( stack[ i ] );
					
					// Remove the open elements from the stack
					stack.length = pos;
				}
			}
		};
		
		public function HTMLtoXML( html:String ):String {
			var results:String = "";
			
			Parse(html, {
				start: function( tag:String , attrs:Array, unary:Boolean ):void {
					results += "<" + tag;
			
					for ( var i:int = 0; i < attrs.length; i++ )
						results += " " + attrs[i].name + '="' + attrs[i].escaped + '"';
			
					results += (unary ? "/" : "") + ">";
				},
				end: function( tag:String ):void {
					results += "</" + tag + ">";
				},
				chars: function( text:String ):void {
					results += text;
				},
				comment: function( text:String ):void {
					results += "<!--" + text + "-->";
				}
			});
			
			return results;
		};
		
	//this.HTMLtoDOM = function( html, doc ) {
	//	// There can be only one of these elements
	//	var one = makeMap("html,head,body,title");
	//
	//	// Enforce a structure for the document
	//	var structure = {
	//		link: "head",
	//		base: "head"
	//	};
	//
	//	if ( !doc ) {
	//		if ( typeof DOMDocument != "undefined" )
	//			doc = new DOMDocument();
	//		else if ( typeof document != "undefined" && document.implementation && document.implementation.createDocument )
	//			doc = document.implementation.createDocument("", "", null);
	//		else if ( typeof ActiveX != "undefined" )
	//			doc = new ActiveXObject("Msxml.DOMDocument");
	//
	//	} else
	//		doc = doc.ownerDocument ||
	//			doc.getOwnerDocument && doc.getOwnerDocument() ||
	//			doc;
	//
	//	var elems = [],
	//		documentElement = doc.documentElement ||
	//			doc.getDocumentElement && doc.getDocumentElement();
	//
	//	// If we're dealing with an empty document then we
	//	// need to pre-populate it with the HTML document structure
	//	if ( !documentElement && doc.createElement ) (function(){
	//		var html = doc.createElement("html");
	//		var head = doc.createElement("head");
	//		head.appendChild( doc.createElement("title") );
	//		html.appendChild( head );
	//		html.appendChild( doc.createElement("body") );
	//		doc.appendChild( html );
	//	})();
	//
	//	// Find all the unique elements
	//	if ( doc.getElementsByTagName )
	//		for ( var i in one )
	//			one[ i ] = doc.getElementsByTagName( i )[0];
	//
	//	// If we're working with a document, inject contents into
	//	// the body element
	//	var curParentNode = one.body;
	//
	//	Parse( html, {
	//		start: function( tagName, attrs, unary ) {
	//			// If it's a pre-built element, then we can ignore
	//			// its construction
	//			if ( one[ tagName ] ) {
	//				curParentNode = one[ tagName ];
	//				return;
	//			}
	//
	//			var elem = doc.createElement( tagName );
	//
	//			for ( var attr in attrs )
	//				elem.setAttribute( attrs[ attr ].name, attrs[ attr ].value );
	//
	//			if ( structure[ tagName ] && typeof one[ structure[ tagName ] ] != "boolean" )
	//				one[ structure[ tagName ] ].appendChild( elem );
	//
	//			else if ( curParentNode && curParentNode.appendChild )
	//				curParentNode.appendChild( elem );
	//
	//			if ( !unary ) {
	//				elems.push( elem );
	//				curParentNode = elem;
	//			}
	//		},
	//		end: function( tag ) {
	//			elems.length -= 1;
	//
	//			// Init the new parentNode
	//			curParentNode = elems[ elems.length - 1 ];
	//		},
	//		chars: function( text ) {
	//			curParentNode.appendChild( doc.createTextNode( text ) );
	//		},
	//		comment: function( text ) {
	//			// create comment node
	//		}
	//	});
	//
	//	return doc;
	//};
	
	private function makeMap(str:String):Object
		{
			var obj:Object = {}, items:Array = str.split(",");
			for ( var i:int = 0; i < items.length; i++ )
				obj[ items[i] ] = true;
			return obj;
		}
	}
}