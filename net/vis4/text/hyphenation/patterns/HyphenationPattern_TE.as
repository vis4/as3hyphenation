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
package net.vis4.text.hyphenation.patterns 
{
	// For questions about the Telugu  hyphenation patterns
	// ask Santhosh Thottingal (santhosh dot thottingal at gmail dot com)
	public class HyphenationPattern_TE extends HyphenationPattern
	{
		public function HyphenationPattern_TE() {
			leftmin = 2;
			rightmin = 2;
			shortestPattern = 1;
			longestPattern = 1;
			specialChars = 'ఆఅఇఈఉఊఋఎఏఐఒఔకగఖఘఙచఛజఝఞటఠడఢణతథదధనపఫబభమయరలవశషసహళఱిీాుూృెేొాోైౌ్ఃం';
			patterns = {
				2 : 'అ1ఆ1ఇ1ఈ1ఉ1ఊ1ఋ1ఎ1ఏ1ఐ1ఒ1ఔ1ి1ా1ీ1ు1ూ1ృ1ె1ే1ొ1ో1ౌ1్2ః1ం11క1గ1ఖ1ఘ1ఙ1చ1ఛ1జ1ఝ1ఞ1ట1ఠ1డ1ఢ1ణ1త1థ1ద1ధ1న1ప1ఫ1బ1భ1మ1య1ర1ల1వ1శ1ష1స1హ1ళ1ఱ'
			};
		}
		
	}

}