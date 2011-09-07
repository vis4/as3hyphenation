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
	// For questions about the Tamil hyphenation patterns
	// ask Santhosh Thottingal (santhosh dot thottingal at gmail dot com)
	public class HyphenationPattern_TA extends HyphenationPattern
	{
		public function HyphenationPattern_TA() {
			leftmin = 2;
			rightmin = 2;
			shortestPattern = 1;
			longestPattern = 1;
			specialChars = 'ஆஅஇஈஉஊஎஏஐஒஔகஙசஜஞடணதநபமயரலவஶஷஸஹளழறிீாுூெேொாோைௌௗ்ஃஂ';
			
			patterns = {
				2 : 'அ1ஆ1இ1ஈ1உ1ஊ1எ1ஏ1ஐ1ஒ1ஔ1ி1ா1ீ1ு1ூ1ெ1ே1ொ1ோ1ௌ1ௗ1்2ஃ1ஂ11க1ங1ச1ஜ1ஞ1ட1ண1த1ந1ப1ம1ய1ர1ல1வ1ஶ1ஷ1ஸ1ஹ1ள1ழ1ற'
			};
		}
		
	}

}