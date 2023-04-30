use rutie::Module;

pub fn init(module: &mut Module) {
    module.get_nested_module("Properties");
}
