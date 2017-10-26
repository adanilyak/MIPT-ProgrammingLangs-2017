#ifndef WIDGETS_H
#define WIDGETS_H

#include <stdbool.h>

/* Root struct */
struct Object;

/* Children */
struct Application;
struct Widget;
struct Layout;
struct Label;
struct PushButton;

/* Methods */
#ifdef __cplusplus
extern "C" {
#endif
	/* Object related */
	const char* Object_GetClassName(struct Object* object);
	void Object_Delete(struct Object* object);

	/* Application related */
	struct Application* Application_New(int argc, char *argv[]);
	int Application_Exec(struct Application* application);

	/* Widget related */
	struct Widget* Widget_New(struct Widget* parent);
	void Widget_SetLayout(struct Widget* widget, struct Layout* layout);
	void Widget_SetWindowTitle(struct Widget* widget, char* text);
	void Widget_SetSize(struct Widget* widget, int width, int height);
	void Widget_SetVisible(struct Widget* widget, bool visible);

	/* Layout related */
	struct Layout* VBoxLayout_New(struct Widget* parent);
	void Layout_AddWidget(struct Layout* layout, struct Widget* widget);

	/* Label related */
	struct Label* Label_New(struct Widget* parent);
	void Label_SetText(struct Label* label, char* text);

	/* PushButton related */
	struct PushButton* PushButton_New(struct Widget* parent);
	void PushButton_SetText(struct PushButton* button, char* text);

#ifdef __cplusplus
}
#endif

#endif
