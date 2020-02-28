set(W_MSBUILD 0 CACHE INTERNAL "" FORCE)
set(W_CLANG 0 CACHE INTERNAL "" FORCE)
set(W_VCXX 0 CACHE INTERNAL "" FORCE)
set(W_GCC 0 CACHE INTERNAL "" FORCE)
set(LX_CLANG 0 CACHE INTERNAL "" FORCE)
set(LX_GCC 0 CACHE INTERNAL "" FORCE)
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	# Enforce x64
	set(CMAKE_VS_PLATFORM_NAME "x64" CACHE STRING "" FORCE)
	if(NOT CMAKE_VS_PLATFORM_NAME STREQUAL "x64")
		message(FATAL_ERROR "Only x64 builds are supported!")
	endif()
	set(PLATFORM "Win64" CACHE INTERNAL "" FORCE)
	if(CMAKE_GENERATOR MATCHES "^(Visual Studio)")
		set(W_MSBUILD 1)
	endif()
	if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		set(W_CLANG 1)
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		set(W_VCXX 1)
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		set(W_GCC 1)
	else()
		message("\tWARNING: Unsupported compiler [${CMAKE_CXX_COMPILER_ID}], expect build warnings/errors!")
	endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	set(PLATFORM "Linux"  CACHE INTERNAL "" FORCE)
	if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		set(LX_CLANG 1)
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		set(LX_GCC 1)
	else()
		message("\tWARNING: Unsupported compiler [${CMAKE_CXX_COMPILER_ID}], expect build warnings/errors!")
	endif()
else()
	message(WARNING "Unsupported system [${CMAKE_SYSTEM_NAME}]!")
endif()

if(PLATFORM STREQUAL "Win64")
	# Embed debug info in builds
	string(REPLACE "ZI" "Z7" CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
	string(REPLACE "Zi" "Z7" CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
	string(REPLACE "ZI" "Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
	string(REPLACE "Zi" "Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
elseif(PLATFORM STREQUAL "Linux")
	# Add GLIBCXX_DEBUG compile flag
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		add_definitions(-D_GLIBCXX_DEBUG)
	endif()
endif()