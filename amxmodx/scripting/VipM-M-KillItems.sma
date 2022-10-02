
#include <amxmodx>
#include <json>
#include <reapi>
#include <VipModular>

#define ArraySizeSafe(%1) \
    (%1 == Invalid_Array ? 0 : ArraySize(%1))

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM][M] Kill Items";
public stock const PluginVersion[] = "1.0.0";
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "https://arkanaplugins.ru/plugin/9";
public stock const PluginDescription[] = "Vip modular`s module - Kill Items";

new const MODULE_NAME[] = "KillItems";

public VipM_OnInitModules(){
    register_plugin(PluginName, PluginVersion, PluginAuthor);
    
    VipM_Modules_Register(MODULE_NAME, true);
    VipM_Modules_AddParams(MODULE_NAME,
        "Items", ptCustom, true,
        "Limits", ptLimits, false
    );
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnRead, "@OnReadConfig");
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnActivated, "@OnModuleActivate");
}

@OnReadConfig(const JSON:jCfg, Trie:Params) {
    if(!json_object_has_value(jCfg, "Items")){
        log_amx("[ERROR] Param `Items` required for module `%s`.", MODULE_NAME);
        return VIPM_STOP;
    }

    new JSON:jItems = json_object_get_value(jCfg, "Items");
    new Array:aItems = VipM_IC_JsonGetItems(jItems);
    json_free(jItems);

    if(ArraySizeSafe(aItems) < 1){
        ArrayDestroy(aItems);
        log_amx("[WARNING] Param `Items` is empty.", MODULE_NAME);
        return VIPM_STOP;
    }
    TrieSetCell(Params, "Items", aItems);

    return VIPM_CONTINUE;
}

@OnModuleActivate() {
    RegisterHookChain(RG_CBasePlayer_Killed, "@OnPlayerKilled", true);
}

@OnPlayerKilled(const VictimId, AttackerId, iGib) {
    new Trie:Params = VipM_Modules_GetParams(MODULE_NAME, AttackerId);

    if (!VipM_Params_ExecuteLimitsList(Params, "Limits", AttackerId, Limit_Exec_AND)) {
        return;
    }

    VipM_IC_GiveItems(AttackerId, VipM_Params_GetArr(Params, "Items"));
}
