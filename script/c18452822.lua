--앨리스퀘어
local m=18452822
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(e1)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
cm.square_mana={0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,c)
	local g=c:GetMaterial()
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(att)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SQUARE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(e:GetLabelObject():GetLabel())
	c:RegisterEffect(e1)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LSTN("M")) and c:IsSummonType(SUMMON_TYPE_SQUARE) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	return c:IsPreviousLocation(LSTN("O"))
end
function cm.tfil31(c)
	return c:IsHasSquareMana(ATTRIBUTE_FIRE) and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand()
end
function cm.tfil32(c,e,tp)
	return c:IsHasSquareMana(ATTRIBUTE_FIRE) and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil31,tp,"D",0,1,nil)
			or (e:GetLabel()>0 and Duel.GetFlagEffect(tp,m)<1
				and Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil32,tp,"D",0,1,nil,e,tp))
	end
	local cat=CATEGORY_TOHAND+CATEGORY_SEARCH
	if e:GetLabel()>0 then
		cat=cat+CATEGORY_SPECIAL_SUMMON
	end
	e:SetCategory(cat)
	Duel.SOI(0,cat,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IEMCard(cm.tfil31,tp,"D",0,1,nil)
		or (e:GetLabel()>0 and Duel.GetFlagEffect(tp,m)<1 and Duel.GetLocCount(tp,"M")>0
			and Duel.IEMCard(cm.tfil32,tp,"D",0,1,nil,e,tp)	and Duel.SelectYesNo(tp,aux.Stringid(m,00))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil32,tp,"D",0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil31,tp,"D",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end