use rutie::{Module, Object};

mod properties;

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_ko() {
    Module::from_existing("KO").define(properties::init);
}
