/*
 *  Copyright (c) 2020, Birju Vachhani
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

library flutter_screwdriver;

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'src/helpers/helpers.dart' as helpers;

export 'src/helpers/app_lifecycle_observer_mixin.dart';
export 'src/helpers/clear_focus_navigator_observer.dart';
export 'src/helpers/helpers.dart';
export 'src/routes/fade_scale_page_route.dart';
export 'src/routes/fade_through_page_route.dart';
export 'src/routes/shared_axis_page_route.dart';

part 'build_context/build_context.dart';

part 'color/color.dart';

part 'primitives/double.dart';

part 'primitives/int.dart';

part 'primitives/string.dart';

part 'route/route.dart';

part 'src/helpers/hide_keyboard.dart';

part 'state/state.dart';

part 'text_editing_controller/text_editing_controller.dart';

part 'ui/brightness.dart';

part 'ui/widget.dart';
