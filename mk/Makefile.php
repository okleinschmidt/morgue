ifndef _MKVENDOR_HAVE_MAKEFILE_PHP
_MKVENDOR_HAVE_MAKEFILE_PHP=y

_MKVENDOR_php_VERSION?=5.6.6
_MKVENDOR_php_URL?=http://php.net/distributions/

include mk/include/Makefile.cmi
$(eval $(call configure_make_install,php))

endif
