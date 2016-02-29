#ifndef whitening_h
#define whitening_h

#include <iostream>
#include "basept.h"

/********************************************************************
 *  Whiten an image
 *  Params:
 *  [IN]:
 *       srcData:       Pointer to source data of camera
 *       srcSize:       the size(width, height) of srcData
 *       srcColorSpace: the colorspace of srcData
 *       dstSize:       the size(width, height) of dstData
 *       ifCapture:     if on real time camera state
 *  [OUT]:
 *       dstData:     Pointer to the data which is enhanced
 *
 *  [RET]:
 *       PT_RET_OK:              success
 *       PT_RET_INVALIDPARAM:    if input is invalid
 *       PT_RET_ERR:             can not process image well
 *
 *********************************************************************/
PTS32 AutoWhitening(PTU8* srcData, PTSize srcSize, PTImageFormatEnum srcColorSpace,
                   PTU8* dstData, PTSize dstSize, PTImageFormatEnum dstColorSpace, PTBOOL ifCapture, const std::string filepath = "");



#endif /* whitening_hpp */
