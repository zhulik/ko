use rutie::{Module, Object};

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_ko() {
    Module::new("KO").define(|_module| {});
}
