// This code was autogenerated with `dbus-codegen-rust -r --file org.mpris.MediaPlayer2.Player.xml`, see https://github.com/diwic/dbus-rs
use dbus;
#[allow(unused_imports)]
use dbus::arg;
use dbus_crossroads as crossroads;

pub trait OrgMprisMediaPlayer2Player {
    fn next(&mut self) -> Result<(), dbus::MethodErr>;
    fn previous(&mut self) -> Result<(), dbus::MethodErr>;
    fn pause(&mut self) -> Result<(), dbus::MethodErr>;
    fn play_pause(&mut self) -> Result<(), dbus::MethodErr>;
    fn stop(&mut self) -> Result<(), dbus::MethodErr>;
    fn play(&mut self) -> Result<(), dbus::MethodErr>;
    fn seek(&mut self, offset: i64) -> Result<(), dbus::MethodErr>;
    fn set_position(
        &mut self,
        track_id: dbus::Path<'static>,
        position: i64,
    ) -> Result<(), dbus::MethodErr>;
    fn open_uri(&mut self, uri: String) -> Result<(), dbus::MethodErr>;
    fn playback_status(&self) -> Result<String, dbus::MethodErr>;
    fn loop_status(&self) -> Result<String, dbus::MethodErr>;
    fn set_loop_status(&self, value: String) -> Result<(), dbus::MethodErr>;
    fn rate(&self) -> Result<f64, dbus::MethodErr>;
    fn set_rate(&self, value: f64) -> Result<(), dbus::MethodErr>;
    fn shuffle(&self) -> Result<bool, dbus::MethodErr>;
    fn set_shuffle(&self, value: bool) -> Result<(), dbus::MethodErr>;
    fn metadata(&self) -> Result<arg::PropMap, dbus::MethodErr>;
    fn volume(&self) -> Result<f64, dbus::MethodErr>;
    fn set_volume(&self, value: f64) -> Result<(), dbus::MethodErr>;
    fn position(&self) -> Result<i64, dbus::MethodErr>;
    fn minimum_rate(&self) -> Result<f64, dbus::MethodErr>;
    fn maximum_rate(&self) -> Result<f64, dbus::MethodErr>;
    fn can_go_next(&self) -> Result<bool, dbus::MethodErr>;
    fn can_go_previous(&self) -> Result<bool, dbus::MethodErr>;
    fn can_play(&self) -> Result<bool, dbus::MethodErr>;
    fn can_pause(&self) -> Result<bool, dbus::MethodErr>;
    fn can_seek(&self) -> Result<bool, dbus::MethodErr>;
    fn can_control(&self) -> Result<bool, dbus::MethodErr>;
}

#[derive(Debug)]
pub struct OrgMprisMediaPlayer2PlayerSeeked {
    pub position: i64,
}

impl arg::AppendAll for OrgMprisMediaPlayer2PlayerSeeked {
    fn append(&self, i: &mut arg::IterAppend) {
        arg::RefArg::append(&self.position, i);
    }
}

impl arg::ReadAll for OrgMprisMediaPlayer2PlayerSeeked {
    fn read(i: &mut arg::Iter) -> Result<Self, arg::TypeMismatchError> {
        Ok(OrgMprisMediaPlayer2PlayerSeeked {
            position: i.read()?,
        })
    }
}

impl dbus::message::SignalArgs for OrgMprisMediaPlayer2PlayerSeeked {
    const NAME: &'static str = "Seeked";
    const INTERFACE: &'static str = "org.mpris.MediaPlayer2.Player";
}

pub fn register_org_mpris_media_player2_player<T>(
    cr: &mut crossroads::Crossroads,
) -> crossroads::IfaceToken<T>
where
    T: OrgMprisMediaPlayer2Player + Send + 'static,
{
    cr.register("org.mpris.MediaPlayer2.Player", |b| {
        b.signal::<(i64,), _>("Seeked", ("Position",));
        b.method("Next", (), (), |_, t: &mut T, ()| t.next());
        b.method("Previous", (), (), |_, t: &mut T, ()| t.previous());
        b.method("Pause", (), (), |_, t: &mut T, ()| t.pause());
        b.method("PlayPause", (), (), |_, t: &mut T, ()| t.play_pause());
        b.method("Stop", (), (), |_, t: &mut T, ()| t.stop());
        b.method("Play", (), (), |_, t: &mut T, ()| t.play());
        b.method("Seek", ("Offset",), (), |_, t: &mut T, (Offset,)| {
            t.seek(Offset)
        });
        b.method(
            "SetPosition",
            ("TrackId", "Position"),
            (),
            |_, t: &mut T, (TrackId, Position)| t.set_position(TrackId, Position),
        );
        b.method("OpenUri", ("Uri",), (), |_, t: &mut T, (Uri,)| {
            t.open_uri(Uri)
        });
        b.property::<String, _>("PlaybackStatus")
            .get(|_, t| t.playback_status())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<String, _>("LoopStatus")
            .get(|_, t| t.loop_status())
            .set(|_, t, value| t.set_loop_status(value).map(|_| None))
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true")
            .annotate("org.mpris.MediaPlayer2.property.optional", "true");
        b.property::<f64, _>("Rate")
            .get(|_, t| t.rate())
            .set(|_, t, value| t.set_rate(value).map(|_| None))
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("Shuffle")
            .get(|_, t| t.shuffle())
            .set(|_, t, value| t.set_shuffle(value).map(|_| None))
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true")
            .annotate("org.mpris.MediaPlayer2.property.optional", "true");
        b.property::<arg::PropMap, _>("Metadata")
            .get(|_, t| t.metadata())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<f64, _>("Volume")
            .get(|_, t| t.volume())
            .set(|_, t, value| t.set_volume(value).map(|_| None))
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<i64, _>("Position")
            .get(|_, t| t.position())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "false");
        b.property::<f64, _>("MinimumRate")
            .get(|_, t| t.minimum_rate())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<f64, _>("MaximumRate")
            .get(|_, t| t.maximum_rate())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanGoNext")
            .get(|_, t| t.can_go_next())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanGoPrevious")
            .get(|_, t| t.can_go_previous())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanPlay")
            .get(|_, t| t.can_play())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanPause")
            .get(|_, t| t.can_pause())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanSeek")
            .get(|_, t| t.can_seek())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "true");
        b.property::<bool, _>("CanControl")
            .get(|_, t| t.can_control())
            .annotate("org.freedesktop.DBus.Property.EmitsChangedSignal", "false");
    })
}

use gdnative::prelude::*;

#[derive(NativeClass, Clone, Copy)]
#[inherit(Node)]
pub struct MprisInterface {
    playback: Option<Ref<Node>>,
}

// [TODO] Store data in hash map update on your own, dont try to get metadata in thread.

impl OrgMprisMediaPlayer2Player for MprisInterface {
    fn next(&mut self) -> Result<(), dbus::MethodErr> {
        unsafe {
            self.playback
                .unwrap()
                .assume_safe()
                .call("queue_skip_next", &[]);
        }
        Ok(())
    }

    fn previous(&mut self) -> Result<(), dbus::MethodErr> {
        todo!()
    }

    fn pause(&mut self) -> Result<(), dbus::MethodErr> {
        unsafe {
            self.playback.unwrap().assume_safe().call("pause", &[]);
        }
        Ok(())
    }

    fn play_pause(&mut self) -> Result<(), dbus::MethodErr> {
        unsafe {
            self.playback.unwrap().assume_safe().call("play_pause", &[]);
        }
        Ok(())
    }

    fn stop(&mut self) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn play(&mut self) -> Result<(), dbus::MethodErr> {
        unsafe {
            self.playback.unwrap().assume_safe().call("play", &[]);
        }
        Ok(())
    }

    fn seek(&mut self, offset: i64) -> Result<(), dbus::MethodErr> {
        unsafe {
            self.playback
                .unwrap()
                .assume_safe()
                .call("seek_with_offset", &[Variant::from_i64(offset)]);
        }
        Ok(())
    }

    fn set_position(
        &mut self,
        track_id: dbus::Path<'static>,
        position: i64,
    ) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn open_uri(&mut self, uri: String) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn playback_status(&self) -> Result<String, dbus::MethodErr> {
        // godot_dbg!(self.playback);
        // unsafe { Ok((if self.playback.unwrap().assume_safe().get("player.playing".to_string()).to_bool() { "Playing" } else { "Paused" }).to_string()) }
        Ok("Paused".to_string())
    }

    fn loop_status(&self) -> Result<String, dbus::MethodErr> {
        Ok("".to_string())
    }

    fn set_loop_status(&self, value: String) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn rate(&self) -> Result<f64, dbus::MethodErr> {
        Ok(0.0)
    }

    fn set_rate(&self, value: f64) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn shuffle(&self) -> Result<bool, dbus::MethodErr> {
        Ok(false)
    }

    fn set_shuffle(&self, value: bool) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn metadata(&self) -> Result<arg::PropMap, dbus::MethodErr> {
        let mut map = arg::PropMap::new();
        unsafe {
            if let Some(track) = self
                .playback
                .unwrap()
                .assume_safe()
                .get("_current_track")
                .try_to_object::<Node>()
            {
                let metadata = track
                    .assume_safe()
                    .call("_get_mpris_metadata", &[])
                    .to_dictionary();

                // Main Textual Metadata
                map.insert(
                    "xesam:title".to_string(),
                    dbus::arg::Variant(Box::new(metadata.get("title").to_string())),
                );
                map.insert(
                    "xesam:album".to_string(),
                    dbus::arg::Variant(Box::new(metadata.get("album").to_string())),
                );
                map.insert(
                    "mpris:length".to_string(),
                    dbus::arg::Variant(Box::new(metadata.get("length").to_i64())),
                );

                map.insert("xesam:artist".to_string(), dbus::arg::Variant(Box::new(Vec::from([ metadata.get("artist").to_string() ]))));
                
                map.insert(
                    "mpris:artUrl".to_string(),
                    dbus::arg::Variant(Box::new(metadata.get("art").to_string())),
                );
            }
        }
        Ok(map)
    }

    fn volume(&self) -> Result<f64, dbus::MethodErr> {
        Ok(0.0)
    }

    fn set_volume(&self, value: f64) -> Result<(), dbus::MethodErr> {
        Ok(())
    }

    fn position(&self) -> Result<i64, dbus::MethodErr> {
        Ok(0)
    }

    fn minimum_rate(&self) -> Result<f64, dbus::MethodErr> {
        Ok(0.0)
    }

    fn maximum_rate(&self) -> Result<f64, dbus::MethodErr> {
        Ok(0.0)
    }

    fn can_go_next(&self) -> Result<bool, dbus::MethodErr> {
        Ok(true)
    }

    fn can_go_previous(&self) -> Result<bool, dbus::MethodErr> {
        Ok(false)
    }

    fn can_play(&self) -> Result<bool, dbus::MethodErr> {
        Ok(true)
    }

    fn can_pause(&self) -> Result<bool, dbus::MethodErr> {
        Ok(true)
    }

    fn can_seek(&self) -> Result<bool, dbus::MethodErr> {
        Ok(true)
    }

    fn can_control(&self) -> Result<bool, dbus::MethodErr> {
        Ok(true)
    }
}

#[methods]
impl MprisInterface {
    fn new(_owner: &Node) -> Self {
        Self { playback: None }
    }

    #[export]
    fn _ready(&mut self, _owner: &Node) {
        self.playback = _owner.get_node("/root/Playback");
    }

    #[export]
    fn start_serving(&self, _owner: &Node) {
        let conn = dbus::blocking::Connection::new_session().unwrap();
        conn.request_name("org.mpris.MediaPlayer2.cello", false, true, false)
            .unwrap();
        let mut cr = dbus_crossroads::Crossroads::new();
        let iface = register_org_mpris_media_player2_player(&mut cr);
        cr.insert("/org/mpris/MediaPlayer2", &[iface], *self);

        std::thread::spawn(move || {
            cr.serve(&conn).unwrap();
        });
    }
}