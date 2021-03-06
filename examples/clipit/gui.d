/**
Copyright: Guillaume Piolat 2015-2017
Copyright: Ethan Reker 2017
License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
*/
module gui;

import dplug.gui;
import dplug.flatwidgets;
import dplug.client;

import main;

// Plugin GUI, based on FlatBackgroundGUI.
// This allows to use knobs rendered with Knobman
class ClipitGUI : FlatBackgroundGUI!("background.png")
{
public:
nothrow:
@nogc:

    ClipitClient _client;

    this(ClipitClient client)
    {
        _client = client;
        super(500, 500); // size

        // Sets the number of pixels recomputed around dirtied controls.
        // Since we aren't using pbr we can set this value to 0 to save
        // on resources.
        // If you are mixing pbr and flat elements, you may want to set this
        // to a higher value such as 30.
        setUpdateMargin(0);

        // All resources are bundled as a string import.
        // You can avoid resource compilers that way.
        // The only cost is that each resource is in each binary, this creates overhead 
        OwnedImage!RGBA knobImage = loadOwnedImage(cast(ubyte[])(import("knob.png")));
        OwnedImage!RGBA switchOnImage = loadOwnedImage(cast(ubyte[])(import("switchOn.png")));
        OwnedImage!RGBA switchOffImage = loadOwnedImage(cast(ubyte[])(import("switchOff.png")));

        // Creates all widets and adds them as children to the GUI
        // widgets are not visible until their positions have been set
        int numFrames = 101;
        UIFilmstripKnob inputGainKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramInputGain), knobImage, numFrames);
        addChild(inputGainKnob);
        UIFilmstripKnob clipKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramClip), knobImage, numFrames);
        addChild(clipKnob);
        UIFilmstripKnob outputGainKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramOutputGain), knobImage, numFrames);
        addChild(outputGainKnob);
        UIFilmstripKnob mixKnob = mallocNew!UIFilmstripKnob(context(), cast(FloatParameter) _client.param(paramMix), knobImage, numFrames);
        addChild(mixKnob);
        UIImageSwitch modeSwitch = mallocNew!UIImageSwitch(context(), cast(BoolParameter) _client.param(paramMode), switchOnImage, switchOffImage);
        addChild(modeSwitch);

        // Builds the UI hierarchy
        // Note: when Dplug has resizeable UI, all positionning is going 
        // to move into a reflow() override.
        // Meanwhile, we hardcode each position.
        immutable int knobX1 = 70;
        immutable int knobX2 = 308;
        immutable int knobY1 = 101;
        immutable int knobY2 = 320;
        immutable int knobWidth = 128;
        immutable int knobHeight = 128;

        inputGainKnob.position = box2i(knobX1, knobY1, knobX1 + knobWidth, knobY1 + knobHeight);
        clipKnob.position = box2i(knobX2, knobY1, knobX2 + knobWidth, knobY1 + knobHeight);
        outputGainKnob.position = box2i(knobX1, knobY2, knobX1 + knobWidth, knobY2 + knobHeight);
        mixKnob.position = box2i(knobX2, knobY2, knobX2 + knobWidth, knobY2 + knobHeight);

        immutable int switchX = 380;
        immutable int switchY = 28;
        immutable int switchWidth = 51;
        immutable int switchHeight = 21;

        modeSwitch.position = box2i(switchX, switchY, switchX + switchWidth, switchY  + switchHeight);
    }

}
