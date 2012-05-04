/*
 * Copyright (c) 2007-2009 Concurrent, Inc. All Rights Reserved.
 *
 * Project and contact information: http://www.cascading.org/
 *
 * This file is part of the Cascading project.
 *
 * Cascading is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Cascading is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cascading.  If not, see <http://www.gnu.org/licenses/>.
 */

package multitool;

import multitool.factory.Factory;

/**
 *
 */
public class Option
  {
  String name = null;
  boolean needs_data = false;
  Factory factory = null;

  public Option (String name, boolean needs_data, Factory factory )
    {
      this.name = name;
      this.needs_data = needs_data;
      this.factory = factory;
    }

  public boolean needsData ()
    {
      return this.needs_data;
    }

  public boolean isValid (String arg_verb, String arg_data )
    {
      if ( needsData() && ( arg_data == null ) )
        return false;
      else if ( !needsData() && ( arg_data != null ) )
        return false;
      else
        return true;
    }
  }
