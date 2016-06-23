// Copyright (c) 2016 Ultimaker B.V.
// Cura is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.1 as UM
import Cura 1.0 as Cura

Rectangle
{
    id: base;
    UM.I18nCatalog { id: catalog; name:"cura"}

    property real progress: Cura.MachineManager.printerOutputDevices[0].progress;
    property int backendState: UM.Backend.state;

    property bool activity: Printer.getPlatformActivity;
    property int totalHeight: childrenRect.height + UM.Theme.getSize("default_margin").height
    property string fileBaseName
    property string statusText:
    {
        if(Cura.MachineManager.printerOutputDevices[0].jobState == "printing")
        {
            return "Printing..."
        } else if(Cura.MachineManager.printerOutputDevices[0].jobState == "paused")
        {
            return "Paused"
        }
        else if(Cura.MachineManager.printerOutputDevices[0].jobState == "pre_print")
        {
            return "Preparing..."
        }
        else
        {
            return " "
        }

    }

    Label
    {
        id: statusLabel
        width: parent.width - 2 * UM.Theme.getSize("default_margin").width
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: UM.Theme.getSize("default_margin").width

        color: Cura.MachineManager.printerOutputDevices[0].jobState == "paused" ? UM.Theme.getColor("status_paused") : UM.Theme.getColor("status_ready")
        font: UM.Theme.getFont("large")
        text: statusText;
    }

    Label
    {
        id: percentageLabel
        anchors.top: parent.top
        anchors.right: progressBar.right
        //anchors.rightMargin: UM.Theme.getSize("default_margin").width

        color: Cura.MachineManager.printerOutputDevices[0].jobState == "paused" ? UM.Theme.getColor("status_paused") : UM.Theme.getColor("status_ready")
        font: UM.Theme.getFont("large")
        text: Math.round(progress * 100) + "%" ;
    }

    Rectangle
    {
        id: progressBar
        width: parent.width - 2 * UM.Theme.getSize("default_margin").width
        height: UM.Theme.getSize("progressbar").height
        anchors.top: statusLabel.bottom
        anchors.topMargin: UM.Theme.getSize("default_margin").height / 4
        anchors.left: parent.left
        anchors.leftMargin: UM.Theme.getSize("default_margin").width
        radius: UM.Theme.getSize("progressbar_radius").width
        color: UM.Theme.getColor("progressbar_background")

        Rectangle
        {
            width: Math.max(parent.width * base.progress)
            height: parent.height
            color: Cura.MachineManager.printerOutputDevices[0].jobState == "paused" ? UM.Theme.getColor("status_paused") : UM.Theme.getColor("status_ready")
            radius: UM.Theme.getSize("progressbar_radius").width
        }
    }

     Button
     {
        id: abortButton

        enabled: true
        height: UM.Theme.getSize("save_button_save_to_button").height

        anchors.top: progressBar.bottom
        anchors.topMargin: UM.Theme.getSize("default_margin").height
        anchors.right: parent.right
        anchors.rightMargin: UM.Theme.getSize("default_margin").width

        text: catalog.i18nc("@label:", "Abort Job")
        onClicked: { Cura.MachineManager.printerOutputDevices[0].setJobState("abort") }


        style: ButtonStyle
        {
            background: Rectangle
            {
                border.width: UM.Theme.getSize("default_lining").width
                border.color: !control.enabled ? UM.Theme.getColor("action_button_disabled_border") :
                                  control.pressed ? UM.Theme.getColor("action_button_active_border") :
                                  control.hovered ? UM.Theme.getColor("action_button_hovered_border") : UM.Theme.getColor("action_button_border")
                color: !control.enabled ? UM.Theme.getColor("action_button_disabled") :
                           control.pressed ? UM.Theme.getColor("action_button_active") :
                           control.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
                Behavior on color { ColorAnimation { duration: 50; } }

                implicitWidth: actualLabel.contentWidth + (UM.Theme.getSize("default_margin").width * 2)

                Label
                {
                    id: actualLabel
                    anchors.centerIn: parent
                    color: !control.enabled ? UM.Theme.getColor("action_button_disabled_text") :
                               control.pressed ? UM.Theme.getColor("action_button_active_text") :
                               control.hovered ? UM.Theme.getColor("action_button_hovered_text") : UM.Theme.getColor("action_button_text")
                    font: UM.Theme.getFont("action_button")
                    text: control.text;
                }
            }
        label: Item { }
        }
     }

     Button
     {
        id: pauseButton

        height: UM.Theme.getSize("save_button_save_to_button").height

        anchors.top: progressBar.bottom
        anchors.topMargin: UM.Theme.getSize("default_margin").height
        anchors.right: abortButton.left
        anchors.rightMargin: UM.Theme.getSize("default_margin").width

        text: Cura.MachineManager.printerOutputDevices[0].jobState == "paused" ? catalog.i18nc("@label:", "Resume") : catalog.i18nc("@label:", "Pause")
        onClicked: { Cura.MachineManager.printerOutputDevices[0].jobState == "paused" ? Cura.MachineManager.printerOutputDevices[0].setJobState("print") : Cura.MachineManager.printerOutputDevices[0].setJobState("pause") }

        style: ButtonStyle
        {
            background: Rectangle
            {
                border.width: UM.Theme.getSize("default_lining").width
                border.color: !control.enabled ? UM.Theme.getColor("action_button_disabled_border") :
                                  control.pressed ? UM.Theme.getColor("action_button_active_border") :
                                  control.hovered ? UM.Theme.getColor("action_button_hovered_border") : UM.Theme.getColor("action_button_border")
                color: !control.enabled ? UM.Theme.getColor("action_button_disabled") :
                           control.pressed ? UM.Theme.getColor("action_button_active") :
                           control.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
                Behavior on color { ColorAnimation { duration: 50; } }

                implicitWidth: actualLabel.contentWidth + (UM.Theme.getSize("default_margin").width * 2)

                Label
                {
                    id: actualLabel
                    anchors.centerIn: parent
                    color: !control.enabled ? UM.Theme.getColor("action_button_disabled_text") :
                               control.pressed ? UM.Theme.getColor("action_button_active_text") :
                               control.hovered ? UM.Theme.getColor("action_button_hovered_text") : UM.Theme.getColor("action_button_text")
                    font: UM.Theme.getFont("action_button")
                    text: control.text;
                }
            }
        label: Item { }
        }
    }
}