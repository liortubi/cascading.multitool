/*
 * Copyright (c) 2007-2013 Concurrent, Inc. All Rights Reserved.
 *
 * Project and contact information: http://www.cascading.org/
 *
 * This file is part of the Cascading project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

  public Option( String name, boolean needs_data, Factory factory )
    {
    this.name = name;
    this.needs_data = needs_data;
    this.factory = factory;
    }

  public boolean needsData()
    {
    return this.needs_data;
    }

  public boolean isValid( String arg_verb, String arg_data )
    {
    if( needsData() && ( arg_data == null ) )
      return false;
    else if( !needsData() && ( arg_data != null ) )
      return false;
    else
      return true;
    }
  }
