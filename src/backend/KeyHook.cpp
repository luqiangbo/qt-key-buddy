#ifdef _WIN32
#include <windows.h>

static HHOOK g_keyboardHook = nullptr;

static LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam) {
	if (nCode == HC_ACTION && wParam == WM_KEYDOWN) {
		const KBDLLHOOKSTRUCT* p = reinterpret_cast<KBDLLHOOKSTRUCT*>(lParam);
		// Example: intercept F1 (just a placeholder)
		if (p && p->vkCode == VK_F1) {
			// Block or transform as needed in future
			return 1;
		}
	}
	return CallNextHookEx(g_keyboardHook, nCode, wParam, lParam);
}

static void installHook() {
	if (!g_keyboardHook) {
		g_keyboardHook = SetWindowsHookExW(WH_KEYBOARD_LL, LowLevelKeyboardProc, GetModuleHandleW(nullptr), 0);
	}
}

static void uninstallHook() {
	if (g_keyboardHook) {
		UnhookWindowsHookEx(g_keyboardHook);
		g_keyboardHook = nullptr;
	}
}
#endif


