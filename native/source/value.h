#pragma once

#include <cstdint>
#include <functional>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

namespace original {

class Runtime;
struct Node;
struct Environment;

struct Value {
    enum Kind { UNDEFINED, NULL_VALUE, BOOLEAN, NUMBER, STRING, OBJECT } kind = UNDEFINED;
    double numeric = 0;
    std::string string;
    Node *node = nullptr;

    Value() = default;
    Value(double value) : kind(NUMBER), numeric(value) {}
    Value(int value) : Value(static_cast<double>(value)) {}
    Value(bool value) : kind(BOOLEAN), numeric(value ? 1 : 0) {}
    Value(const char *value) : kind(STRING), string(value) {}
    Value(const std::string &value) : kind(STRING), string(value) {}
    explicit Value(Node *value) : kind(OBJECT), node(value) {}
    static Value null() { Value value; value.kind = NULL_VALUE; return value; }
};

using Arguments = std::vector<Value>;
using Function = Value (*)(Runtime &, Value, const Arguments &, Environment *, Value);
using HostFunction = std::function<Value(Runtime &, Value, const Arguments &)>;

struct Node {
    bool marked = false;
    bool array = false;
    bool callable = false;
    int array_type = 0;
    Node *prototype = nullptr;
    std::unordered_map<std::string, Value> fields;
    std::vector<std::string> property_order;
    Arguments elements;
    Environment *closure = nullptr;
    Function function = nullptr;
    HostFunction host;
};

struct Environment {
    bool marked = false;
    Environment *parent = nullptr;
    Arguments slots;
    Environment *ancestor(int depth) { auto result = this; while (depth-- > 0) result = result->parent; return result; }
};

class Runtime {
    std::vector<std::unique_ptr<Node>> nodes;
    std::vector<std::unique_ptr<Environment>> environments;
    Node *object_prototype = nullptr;
    Node *array_prototype = nullptr;
    Node *function_prototype = nullptr;
    std::unordered_map<std::string, Value> globals;
    void mark(Value value);
    void mark(Environment *environment);
    Node *allocate();

public:
    uint64_t instruction_budget = 0;
    void checkpoint(int function, int offset);
    std::unordered_map<Function, std::string> function_names;
    Runtime();
    Environment *environment(Environment *parent, size_t count);
    Value global(const std::string &name) const;
    void set_global(const std::string &name, Value value) { globals[name] = value; }
    void install_spine_builtins();
    Value regexp(const std::string &pattern, const std::string &flags);
    std::vector<std::string> keys(Value object) const;
    Value object();
    Value array(const Arguments &items = {});
    Value function(Function function, Environment *closure);
    Value host(HostFunction callback);
    Value get(Value object, Value key) const;
    Value set(Value object, Value key, Value value);
    Value erase(Value object, Value key);
    Value invoke(Value function, Value receiver, const Arguments &arguments);
    Value construct(Value function, const Arguments &arguments);
    Value binary(const std::string &operation, Value left, Value right) const;
    Value unary(const std::string &operation, Value value) const;
    bool truthy(Value value) const;
    double number(Value value) const;
    std::string text(Value value) const;
    bool equal(Value left, Value right, bool strict) const;
    void collect(const Arguments &roots);
};

Value initialize_box2d(Runtime &runtime);
Value initialize_spine(Runtime &runtime);
Function box2d_function(size_t index);
int box2d_function_id(Function function);

}
