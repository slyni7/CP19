--ÁøÈ¯¼ö °¡Á¬Æ®
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2,s.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetTR("M","M")
	e2:SetTarget(function(e,c)
		return e:GetHandler():GetLinkedGroup():IsContains(c)
	end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTR("M","M")
	e3:SetTarget(s.tar3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.pfil1(c)
	return c:IsSetCard("°¡Á¬Æ®")
end
function s.pfun1(g,lc,sumtype,tp)
	return g:IsExists(s.pfil1,1,nil)
end
function s.val1(e,c)
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SKULL) and tc:IsCustomType(CUSTOMTYPE_SKULL) then
			local mg=tc:GetMaterial()
			local mc=mg:GetFirst()
			while mc do
				local tatk=mc:GetTextAttack()*2
				if tatk>0 then
					atk=atk+tatk
				end
				mc=mg:GetNext()
			end
		end
		local tatk=tc:GetTextAttack()
		if tatk>0 then
			atk=atk+tatk
		end
		tc=g:GetNext()
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
end
function s.tar3(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end