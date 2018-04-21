## Copyright (C) 2018 Davide
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} Ray (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Davide <davide@davide-X556UV>
## Created: 2018-04-18

function r = Ray ()
pkg load image
wiIm = "~/Dropbox/SC/dati/Fractalis/Fractalis__Dla_or/frames/Working DLA.png";
  count = 0;
  I = imread(wiIm);
  I(find(I!=255)) = 1;
  I(find(I==255)) = 0;
  ystart = size(I)(2)/2;
  xstart = size(I)(1)/2*size(I)(2);
  size = size(I)(2);
  out =  [];
  for R = 0:2:6
     for i = -R:1:R
        for j = -R:1:R
         y = ystart + j;
        x = xstart  + i*size;
        count+=I(x+y);
       endfor
      endfor
    out = [out; [R, count]];
   endfor
   save NvsR.dat out

endfunction
