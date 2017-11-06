#include <Python/Python.h>

#include "widgets.h"

static PyObject* Py_Object_GetClassName(PyObject* self, PyObject* args) {
	PyObject* object;
	if (!PyArg_ParseTuple(args, "O", &object)) {
		return NULL;
	}

	return Py_BuildValue("s", Object_GetClassName((struct Object*)object));
}

static char Py_Object_GetClassName_Docs[] = "Get class name";

static PyMethodDef PyWidgetsFuncs[] = {
    {"Object_GetClassName", (PyCFunction)Py_Object_GetClassName, METH_VARARGS, Py_Object_GetClassName_Docs},
    {NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC PyWidgetsInit(void) {
    Py_InitModule3("_pywidgets", PyWidgetsFuncs, "Python Widgets Lib");
}

int main() {}