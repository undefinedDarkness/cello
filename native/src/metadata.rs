use lofty::{ read_from_path, Accessor, MimeType };
use gdnative::prelude::*;
#[derive(NativeClass, Default, Copy, Clone)]
#[user_data(Aether<AudioMetadata>)]
#[inherit(Object)]
pub struct AudioMetadata;

#[methods]
impl AudioMetadata {

    fn new(_owner: &Object) -> Self {
        return Self { }
    }
    
    #[export]
    fn get_textual_metadata(&self, _owner: &Object, path: String) -> Dictionary<Unique>  {
        let dict = Dictionary::new();
        if let Ok(tf) = read_from_path(path, false) {
            let tag = tf.primary_tag().unwrap_or_else(|| {
                godot_error!("Failed to get first tag.");
                tf.first_tag().unwrap()
            });
            dict.insert("title", tag.title());
            dict.insert("artist", tag.artist());
            dict.insert("album", tag.album());
            dict.insert("genre", tag.genre());
        } 
        return dict;
    }

    #[export]
    fn get_album_art(&self, _owner: &Object, path: String) -> Variant {
        let tag = read_from_path(&path, false).unwrap();
        let tag = tag.primary_tag().unwrap_or_else(|| tag.first_tag().unwrap());
        if tag.picture_count() == 0 {
            godot_print!("No artwork found in {}", &path);
            return Variant::new();
        }
        let picture = &tag.pictures()[0];
        let image = gdnative::api::Image::new();
        let picture_t = picture.mime_type();
        match picture_t {
            MimeType::Png => image.load_png_from_buffer(TypedArray::from_slice(picture.data())),
            MimeType::Jpeg => image.load_jpg_from_buffer(TypedArray::from_slice(picture.data())),
            _ => {
                godot_print!("Artwork of invalid type found {}", picture_t.to_string());
                return Variant::new();
            }
        }.unwrap();
        return Variant::from_object(image);
    }
}

