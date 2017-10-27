#ifndef OBJECT_H
#define OBJECT_H

#include "widgets.h"
#include <string.h>
#include <vector>

#include <QObject>

/* Object */

class Object: public QObject {
	Q_OBJECT
public:
	std::vector<Object*>* children;

	/* Action related */
	struct Object* sender;
	Action* action;

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

public Q_SLOTS:
	void onClick() {
		if (action != NULL) {
			(*action)(sender);
		}
	}

};

#endif