#pragma once

#include <godot_cpp/classes/ref_counted.hpp>

namespace tank_trouble {

class TTJavaScriptValues : public godot::RefCounted {
    GDCLASS(TTJavaScriptValues, godot::RefCounted)

protected:
    static void _bind_methods();

public:
    godot::String number_to_string(double value) const;
};

}
