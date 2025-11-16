#ifdef _WIN32
#include <windows.h>
#include <wingdi.h>
#include <QImage>

static QImage HBITMAPToImage(HBITMAP hBitmap) {
	if (!hBitmap) return {};
	BITMAP bmp;
	GetObject(hBitmap, sizeof(BITMAP), &bmp);
	QImage img(bmp.bmWidth, bmp.bmHeight, QImage::Format_ARGB32);
	HDC hdc = GetDC(nullptr);
	BITMAPINFO bmi = { 0 };
	bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	bmi.bmiHeader.biWidth = bmp.bmWidth;
	bmi.bmiHeader.biHeight = -bmp.bmHeight; // top-down
	bmi.bmiHeader.biPlanes = 1;
	bmi.bmiHeader.biBitCount = 32;
	bmi.bmiHeader.biCompression = BI_RGB;
	GetDIBits(hdc, hBitmap, 0, bmp.bmHeight, img.bits(), &bmi, DIB_RGB_COLORS);
	ReleaseDC(nullptr, hdc);
	return img;
}

static HBITMAP CaptureScreenHBITMAP() {
	RECT rc;
	GetWindowRect(GetDesktopWindow(), &rc);
	const int width = rc.right - rc.left;
	const int height = rc.bottom - rc.top;
	HDC hScreen = GetDC(nullptr);
	HDC hMem = CreateCompatibleDC(hScreen);
	HBITMAP hBitmap = CreateCompatibleBitmap(hScreen, width, height);
	HGDIOBJ old = SelectObject(hMem, hBitmap);
	BitBlt(hMem, 0, 0, width, height, hScreen, 0, 0, SRCCOPY);
	SelectObject(hMem, old);
	DeleteDC(hMem);
	ReleaseDC(nullptr, hScreen);
	return hBitmap;
}

QImage CaptureScreen() {
	HBITMAP hbm = CaptureScreenHBITMAP();
	QImage img = HBITMAPToImage(hbm);
	DeleteObject(hbm);
	return img;
}
#endif


