
#include <amxmodx>
#include <json>
#include <reapi>
#include <VipModular>

#define ArraySizeSafe(%1) \
    (%1 == Invalid_Array ? 0 : ArraySize(%1))

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-M] Kill Items";
public stock const PluginVersion[] = "1.1.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "t.me/arkanaplugins";
public stock const PluginDescription[] = "Vip modular`s module - Kill Items";

new const MODULE_NAME[] = "KillItems";

public VipM_OnInitModules() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);
    
    VipM_Modules_Register(MODULE_NAME, true);
    VipM_Modules_AddParams(MODULE_NAME,
        "Items", ptCustom, false,
        "DefaultItems", ptCustom, false,
        "HeadItems", ptCustom, false,
        "KnifeItems", ptCustom, false
    );
    VipM_Modules_AddParams(MODULE_NAME,
        "Limits", ptLimits, false
    );
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnRead, "@OnReadConfig");
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnActivated, "@OnModuleActivate");
}

@OnReadConfig(const JSON:jCfg, Trie:Params) {
    new Array:aItems = VipM_IC_JsonGetItems(json_object_get_value(jCfg, "Items"));
    new Array:aDefaultItems = VipM_IC_JsonGetItems(json_object_get_value(jCfg, "DefaultItems"));
    new Array:aHeadItems = VipM_IC_JsonGetItems(json_object_get_value(jCfg, "HeadItems"));
    new Array:aKnifeItems = VipM_IC_JsonGetItems(json_object_get_value(jCfg, "KnifeItems"));

    if (
        ArraySizeSafe(aItems) < 1
        && ArraySizeSafe(aDefaultItems) < 1
        && ArraySizeSafe(aHeadItems) < 1
        && ArraySizeSafe(aKnifeItems) < 1
    ) {
        VipM_Json_LogForFile(jCfg, "[WARNING] One of 'items' param must be filled.", MODULE_NAME);
        return VIPM_STOP;
    }

    TrieSetCell(Params, "Items", aItems);
    TrieSetCell(Params, "DefaultItems", aDefaultItems);
    TrieSetCell(Params, "HeadItems", aHeadItems);
    TrieSetCell(Params, "KnifeItems", aKnifeItems);

    return VIPM_CONTINUE;
}

@OnModuleActivate() {
    RegisterHookChain(RG_CBasePlayer_Killed, "@OnPlayerKilled", true);
}

@OnPlayerKilled(const VictimId, AttackerId, iGib) {
    new Trie:tParams = VipM_Modules_GetParams(MODULE_NAME, AttackerId);

    if (!VipM_Params_ExecuteLimitsList(tParams, "Limits", AttackerId, Limit_Exec_AND)) {
        return;
    }

    VipM_IC_GiveItems(AttackerId, VipM_Params_GetArr(tParams, "Items"));
    
    new iActiveItemId = get_member(AttackerId, m_pActiveItem);
    if (
        !(get_member(VictimId, m_bitsDamageType) & DMG_SLASH)
        && is_entity(iActiveItemId)
        && rg_get_iteminfo(iActiveItemId, ItemInfo_iId) == CSW_KNIFE
    ) {
        VipM_IC_GiveItems(AttackerId, VipM_Params_GetArr(tParams, "KnifeItems"));
    } else if (get_member(VictimId, m_bHeadshotKilled)) {
        VipM_IC_GiveItems(AttackerId, VipM_Params_GetArr(tParams, "HeadItems"));
    } else {
        VipM_IC_GiveItems(AttackerId, VipM_Params_GetArr(tParams, "DefaultItems"));
    }
}
