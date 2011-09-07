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
	// For questions about the Gujarati hyphenation patterns
	// ask Santhosh Thottingal (santhosh dot thottingal at gmail dot com
	public class HyphenationPattern_GU extends HyphenationPattern
	{
		public function HyphenationPattern_GU() {
			leftmin = 2;
			rightmin = 2;
			shortestPattern = 1;
			longestPattern = 1;
			specialChars = unescape('આઅઇઈઉઊઋએઐઔકગખઘઙચછજઝઞટઠડઢણતથદધનપફબભમયરલવશષસહળિીાુૂૃેાોૈૌ્ઃં%u200D');
			patterns = {
				2 : 'અ1આ1ઇ1ઈ1ઉ1ઊ1ઋ1એ1ઐ1ઔ1િ1ા1ી1ુ1ૂ1ૃ1ે1ો1ૌ1્2ઃ1ં11ક1ગ1ખ1ઘ1ઙ1ચ1છ1જ1ઝ1ઞ1ટ1ઠ1ડ1ઢ1ણ1ત1થ1દ1ધ1ન1પ1ફ1બ1ભ1મ1ય1ર1લ1વ1શ1ષ1સ1હ1ળ'
			};
		}
	}

}