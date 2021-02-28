# - Try to find libpcap include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(PCAP)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
# Targets defined by this module:
#
#  PCAP::PCAP                Recommended PCAP target to link against
#
# Variables defined by this module:
#
#  PCAP_FOUND                System has libpcap, include and library dirs found
#  PCAP_INCLUDE_DIR          The libpcap include directories.
#  PCAP_LIBRARY              The libpcap library (possibly includes a thread
#                            library e.g. required by pf_ring's libpcap)

find_package(PkgConfig)
pkg_check_modules(PC_PCAP QUIET pcap)
find_path(PCAP_ROOT_DIR
    NAMES include/pcap.h
    PATHS ${PC_PCAP_INCLUDE_DIRS}
)
set(PCAP_VERSION ${PC_PCAP_VERSION})
mark_as_advanced(PCAP_FOUND PCAP_INCLUDE_DIR PCAP_VERSION)

find_path(PCAP_INCLUDE_DIR
    NAMES pcap.h
    HINTS ${PCAP_ROOT_DIR}/include
)
find_library(PCAP_LIBRARY
    NAMES pcap
    HINTS ${PCAP_ROOT_DIR}/lib
)

mark_as_advanced(
    PCAP_ROOT_DIR
    PCAP_INCLUDE_DIR
    PCAP_LIBRARY
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PCAP DEFAULT_MSG
    PCAP_LIBRARY
    PCAP_INCLUDE_DIR
)

if(PCAP_FOUND AND NOT TARGET PCAP::PCAP)
    add_library(PCAP::PCAP INTERFACE IMPORTED)
    set_target_properties(PCAP::PCAP PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PCAP_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "${PCAP_LIBRARY}"
    )

    message(STATUS "Found pcap")
endif()
