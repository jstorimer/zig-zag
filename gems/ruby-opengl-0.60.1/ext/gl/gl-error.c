/*
 * Copyright (C) 2007 Jan Dvorak <jan.dvorak@kraxnet.cz>
 *
 * This program is distributed under the terms of the MIT license.
 * See the included MIT-LICENSE file for the terms of this license.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include "../common/common.h"

VALUE error_checking = Qtrue;

VALUE Class_GLError;

#define BUFSIZE 256

void check_for_glerror(void)
{
	GLenum error;

	error = glGetError();

	if (error==GL_NO_ERROR) { /* no errors == instant return */
		return;
	} else { /* process errors */
		const char *error_string;
		int queued_errors = 0;
		char message[BUFSIZE];
		VALUE exc;
	
		/* check for queued errors */
		for(queued_errors = 0;
				glGetError()!=GL_NO_ERROR;
				queued_errors++)
			;
		
		switch(error) {
			case GL_INVALID_ENUM: error_string = "invalid enumerant"; break;
			case GL_INVALID_VALUE: error_string = "invalid value"; break;
			case GL_INVALID_OPERATION: error_string = "invalid operation"; break;
			case GL_STACK_OVERFLOW: error_string = "stack overflow"; break;
			case GL_STACK_UNDERFLOW: error_string = "stack underflow"; break;
			case GL_OUT_OF_MEMORY: error_string = "out of memory"; break;
			case GL_TABLE_TOO_LARGE: error_string = "table too large"; break;
			case GL_INVALID_FRAMEBUFFER_OPERATION_EXT: error_string = "invalid framebuffer operation"; break;
			default: error_string = "unknown error"; break;
		}
		
		if (queued_errors==0) {
			snprintf(message,BUFSIZE,"%s",error_string);
		} else {
			snprintf(message,BUFSIZE,"%s [%i queued error(s) cleaned]",error_string,queued_errors);
		}

		exc = rb_funcall(Class_GLError, rb_intern("new"), 2, rb_str_new2(message), INT2NUM(error));
		rb_funcall(rb_cObject, rb_intern("raise"), 1, exc);
	}
}

VALUE GLError_initialize(VALUE obj,VALUE message, VALUE error_id)
{
	rb_call_super(1, &message);
	rb_iv_set(obj, "@id", error_id);

	return obj;
}

static VALUE enable_error_checking(VALUE obj)
{
	error_checking = Qtrue;
	return Qnil;
}

static VALUE disable_error_checking(VALUE obj)
{
	error_checking = Qfalse;
	return Qnil;
}

static VALUE is_error_checking_enabled(VALUE obj)
{
	return error_checking;
}

void gl_init_error(VALUE module)
{
	Class_GLError = rb_define_class_under(module, "Error", rb_eStandardError);

	rb_define_method(Class_GLError, "initialize", GLError_initialize, 2);
	rb_define_attr(Class_GLError, "id", 1, 0);

	rb_define_module_function(module, "enable_error_checking", enable_error_checking, 0);
	rb_define_module_function(module, "disable_error_checking", disable_error_checking, 0);
	rb_define_module_function(module, "is_error_checking_enabled?", is_error_checking_enabled, 0);

	rb_global_variable(&error_checking);
}
