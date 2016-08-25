ifndef PETA_STAGE
$(error "Error: PETA_STAGE environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif
include ../apps.common.mk

APP = timer

all: build 


build:	
	$(CC) $(LDFLAGS) -Ilib_rw $(CFLAGS) timing.cxx -lrwreg -o ./timer 
	# $(CC) $(LDFLAGS) -fnon-call-exceptions -Ilib_rw -c $(CFLAGS) timing.cxx -llibrwreg -o ./timer

install: $(APP)
	$(TARGETINST) -d $(APP) /bin/$(APP)


# $(APP):$(APP_OBJS)
# 	$(CXX) -std=c++0x $(LDFLAGS) -fnon-call-exceptions -shared -o $@.so $(APP_OBJS) 

