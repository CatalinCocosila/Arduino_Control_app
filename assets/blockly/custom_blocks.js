Blockly.Blocks['start'] = {
    init: function() {
        this.appendDummyInput().appendField("Când începe programul");
        this.setNextStatement(true, null);
        this.setColour(230);
        this.setTooltip("Bloc de start");
    }
};

Blockly.Blocks['move_up'] = {
    init: function() {
        this.appendDummyInput().appendField("Mergi înainte");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(120);
    }
};

Blockly.Blocks['move_down'] = {
    init: function() {
        this.appendDummyInput().appendField("Mergi înapoi");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(120);
    }
};

Blockly.Blocks['move_left'] = {
    init: function() {
        this.appendDummyInput().appendField("Mergi la stânga");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(120);
    }
};

Blockly.Blocks['move_right'] = {
    init: function() {
        this.appendDummyInput().appendField("Mergi la dreapta");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(120);
    }
};

Blockly.Blocks['repeat'] = {
    init: function() {
        this.appendDummyInput()
            .appendField("Repetă de")
            .appendField(new Blockly.FieldNumber(1, 1), "TIMES")
            .appendField("ori");
        this.appendStatementInput("DO").setCheck(null);
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(290);
    }
};
