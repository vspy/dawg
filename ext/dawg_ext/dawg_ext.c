#include <ruby.h>

VALUE module = Qnil;

/* ruby calls this to load the extension */
void Init_dawg_ext(void) {
  module = rb_define_module("Dawg");
}

