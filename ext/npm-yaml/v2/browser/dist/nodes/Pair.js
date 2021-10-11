import { createNode } from '../doc/createNode.js';
import { stringifyPair } from '../stringify/stringifyPair.js';
import { addPairToJSMap } from './addPairToJSMap.js';
import { NODE_TYPE, PAIR } from './Node.js';

function createPair(key, value, ctx) {
    const k = createNode(key, undefined, ctx);
    const v = createNode(value, undefined, ctx);
    return new Pair(k, v);
}
class Pair {
    constructor(key, value = null) {
        Object.defineProperty(this, NODE_TYPE, { value: PAIR });
        this.key = key;
        this.value = value;
    }
    toJSON(_, ctx) {
        const pair = ctx && ctx.mapAsMap ? new Map() : {};
        return addPairToJSMap(ctx, pair, this);
    }
    toString(ctx, onComment, onChompKeep) {
        return ctx && ctx.doc
            ? stringifyPair(this, ctx, onComment, onChompKeep)
            : JSON.stringify(this);
    }
}

export { Pair, createPair };
