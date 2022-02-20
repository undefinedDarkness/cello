use gdnative::prelude::*;
mod mpris;
mod metadata;

fn init(handle: InitHandle) {
    handle.add_class::<crate::metadata::AudioMetadata>();
    handle.add_class::<crate::mpris::MprisInterface>();
}

godot_init!(init);
