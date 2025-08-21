/***************************************************************************
Copyright (C) 2007 by Nach
http://nsrt.edgeemu.com

Copyright (C) 2007-2011 by sinamas <sinamas at users.sourceforge.net>
sinamas@users.sourceforge.net

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License version 2 for more details.

You should have received a copy of the GNU General Public License
version 2 along with this program; if not, write to the
Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
***************************************************************************/
#include "stdfile.h"

transfer_ptr<gambatte::File> gambatte::newFileInstance(std::string const &filepath) {
	return transfer_ptr<File>(new StdFile(filepath.c_str()));
}
