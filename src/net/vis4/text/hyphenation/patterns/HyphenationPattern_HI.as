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
	// For questions about the Hindi hyphenation patterns
	// ask Santhosh Thottingal (santhosh dot thottingal at gmail dot com)
	public class HyphenationPattern_HI extends HyphenationPattern
	{
		public function HyphenationPattern_HI() {
			leftmin = 2;
			rightmin = 2;
			shortestPattern = 1;
			longestPattern = 1;
			specialChars =  unescape('आअइईउऊऋऎएऐऒऔकगखघङचछजझञटठडढणतथदधनपफबभमयरलवशषसहळऴऱिीाुूृॆेॊाोैौ्ःं%u200D');
			patterns = {
				2 : 'अ1आ1इ1ई1उ1ऊ1ऋ1ऎ1ए1ऐ1ऒ1औ1ि1ा1ी1ु1ू1ृ1ॆ1े1ॊ1ो1ौ1्2ः1ं11क1ग1ख1घ1ङ1च1छ1ज1झ1ञ1ट1ठ1ड1ढ1ण1त1थ1द1ध1न1प1फ1ब1भ1म1य1र1ल1व1श1ष1स1ह1ळ1ऴ1ऱ'
			};
		}
	}

}