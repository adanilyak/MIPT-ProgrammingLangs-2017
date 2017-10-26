#include "widgets.h"
#include <iostream>
#include <string.h>
#include <vector>

#include <QApplication>
#include <QWidget>
#include <QVBoxLayout>
#include <QLabel>
#include <QPushButton>

/* Object */

struct Object {
	
	std::vector<Object*>* children;

	Object() {
		children = new std::vector<Object*>();
	}

	~Object() {
		for (Object* child: (*children)) {
			delete(child);
		}
		delete(children);
	}

	virtual const char* getClassName() {
		return std::string("Object").c_str();
	}

};

struct Application: public Object {

	QApplication* application;

	Application(int argc, char *argv[]) {
		application = new QApplication(argc, argv);
	}

	~Application() {
		delete(application);
	}

	virtual const char* getClassName() {
		return std::string("Application").c_str();
	}

};

struct Widget: public Object {

	QWidget* widget;

	Widget(struct Widget* parent) {
		widget = new QWidget();
		if (parent != NULL) {
			widget->setParent(parent->widget);
			parent->children->push_back((Object*)this);
		}
	}

	~Widget() {
		delete(widget);
	}

	virtual const char* getClassName() {
		return std::string("Widget").c_str();
	}

};

struct Layout: public Object {

	QVBoxLayout* layout;

	Layout(struct Widget* parent) {
		layout = new QVBoxLayout();
		if (parent != NULL) {
			layout->setParent(parent->widget);
			parent->children->push_back((Object*)this);
		}
	}

	~Layout() {
		delete(layout);
	}

	virtual const char* getClassName() {
		return std::string("VBoxLayout").c_str();
	}

};

struct Label: public Widget {

	Label(struct Widget* parent): Widget(parent) {
		widget = new QLabel();
	}

	~Label() {
		delete(widget);
	}

	virtual const char* getClassName() {
		return std::string("Label").c_str();
	}

};

struct PushButton: public Widget {

	PushButton(struct Widget* parent): Widget(parent) {
		widget = new QPushButton();
	}

	~PushButton() {
		delete(widget);
	}

	virtual const char* getClassName() {
		return std::string("PushButton").c_str();
	}

};

/* Object */

extern "C" const char* Object_GetClassName(struct Object* object) {
	return object->getClassName();
}

extern "C" void Object_Delete(struct Object* object) {
	delete(object);
}

/* Application */

extern "C" struct Application* Application_New(int argc, char *argv[]) {
	return new Application(argc, argv);
}

extern "C" int Application_Exec(struct Application* application) {
	return application->application->exec();
}

/* Widget */

extern "C" struct Widget* Widget_New(struct Widget* parent) {
	return new Widget(parent);
}

extern "C" void Widget_SetLayout(struct Widget* widget, struct Layout* layout) {
	widget->widget->setLayout(layout->layout);
}

extern "C" void Widget_SetWindowTitle(struct Widget* widget, char* text) {
	widget->widget->setWindowTitle(text);
}

extern "C" void Widget_SetSize(struct Widget* widget, int width, int height) {
	widget->widget->resize(width, height);
}

extern "C" void Widget_SetVisible(struct Widget* widget, bool visible) {
	widget->widget->setVisible(visible);
}


/* Layout */

extern "C" struct Layout* VBoxLayout_New(struct Widget* parent) {
	return new Layout(parent);
}

extern "C" void Layout_AddWidget(struct Layout* layout, struct Widget* widget) {
	layout->layout->addWidget(widget->widget);
}

/* Label */

extern "C" struct Label* Label_New(struct Widget* parent) {
	return new Label(parent);
}

extern "C" void Label_SetText(struct Label* label, char* text) {
	((QLabel*)(label->widget))->setText(text);
}

/* PushButton */

extern "C" struct PushButton* PushButton_New(struct Widget* parent) {
	return new PushButton(parent);
}

extern "C" void PushButton_SetText(struct PushButton* button, char* text) {
	((QPushButton*)(button->widget))->setText(text);
}
