Blockly.JavaScript['start'] = function(block) {
    return '';
};

Blockly.JavaScript['move_up'] = function(block) {
    return '"UP",';
};

Blockly.JavaScript['move_down'] = function(block) {
    return '"DOWN",';
};

Blockly.JavaScript['move_left'] = function(block) {
    return '"LEFT",';
};

Blockly.JavaScript['move_right'] = function(block) {
    return '"RIGHT",';
};

Blockly.JavaScript['repeat'] = function(block) {
    var times = block.getFieldValue('TIMES');
    var statements = Blockly.JavaScript.statementToCode(block, 'DO');
    return 'for (var i = 0; i < ' + times + '; i++) {' + statements + '}';
};
