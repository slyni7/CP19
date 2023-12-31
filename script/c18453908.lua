--딸깍딸깍!
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
s.listed_names={18453902,18453903}
function s.tfil11(c,e,tp)
	return not s.tfil12(c) or (Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil13,tp,"DG",0,1,nil,e,tp))
end
function s.tfil12(c)
	return c:IsFaceup() and (c:IsCode(18453902) or c:ListsCode(18453902))
end
function s.tfil13(c,e,tp)
	return c:IsCode(18453903) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc~=c
	end
	if chk==0 then
		return Duel.IETarget(s.tfil11,tp,"O","O",1,c,e,tp)
	end
	local g=Duel.STarget(tp,s.tfil11,tp,"O","O",1,1,c,e,tp)
	local tc=g:GetFirst()
	if s.tfil12(tc) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DG")
	else
		e:SetLabel(0)
		e:SetCategory(0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocCount(tp,"M")>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SMCard(tp,s.tfil13,tp,"DG",0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end