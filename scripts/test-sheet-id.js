import axios from 'axios';

const id1 = '13d_LAJPlxMa_DubPTuirk_g4gRkaY-0AHSqbYxfFIP4';
const id2 = '13d_LAJPlxMa_DubPTuirkIV4DERBMXbrWQsmSh8ReK4';

async function test(id) {
    const url = `https://docs.google.com/spreadsheets/d/${id}/gviz/tq?tqx=out:csv&sheet=Villagers`;
    try {
        const res = await axios.get(url);
        console.log(`ID ${id} SUCCESS, length: ${res.data.length}`);
    } catch (e) {
        console.log(`ID ${id} FAILED: ${e.message}`);
    }
}

test(id1).then(() => test(id2));
